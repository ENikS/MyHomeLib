(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             12.02.2010
  * Description
  * Author(s)           Aleksey Penkov  alex.penkov@gmail.com
  *                     Nick Rymanov (nrymanov@gmail.com)
  *
  * History
  * NickR 15.02.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit unit_Database;

interface

uses
  DB,
  Classes,
  Variants,
  ABSMain,
  unit_Globals;

type
  TABSTableHelper = class helper for TABSTable
    constructor Create(AOwner: TComponent);
  end;

  TMHLLibrary = class(TComponent)
  private
    procedure CheckActive;
    procedure CheckInactive;

    function GetDatabaseFileName: string;
    procedure SetDatabaseFileName(const Value: string);

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);

    procedure LoadGenres(const GenresFileName: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    //
    // Database creation & management
    //
    class procedure CreateSystemTables(const DBFile: string);
    procedure CreateCollectionTables(const DBFile: string; const GenresFileName: string);
    procedure ReloadDefaultGenres(const FileName: string);

    //
    // Content management
    //
    function CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean;

    function InsertBook(BookRecord: TBookRecord; CheckFileName, FullCheck: Boolean): Integer;
    procedure DeleteBook(BookID: Integer; ClearExtra: Boolean = True);
    procedure CorrectExtra(OldID, NewID: Integer);

    procedure AddBookGenre(BookID: Integer; const GenreCode: string);
    procedure CleanBookGenres(BookID: Integer);

    procedure GetSeries(SeriesList: TStrings);

    //
    // Bulk operation
    //
    procedure BeginBulkOperation;
    procedure EndBulkOperation(Commit: Boolean = True);

  public
    function GetGenreAlias(const FB2Code: string): string;
    function GetTopGenreAlias(const FB2Code: string): string;

    property DatabaseFileName: string read GetDatabaseFileName write SetDatabaseFileName;
    property Active: Boolean read GetActive write SetActive;

  private
    FDatabase: TABSDatabase;

    FAuthors: TABSTable;
    FAuthorID: TIntegerField;
    FAuthorLastName: TWideStringField;
    FAuthorFirstName: TWideStringField;
    FAuthorMiddleName: TWideStringField;

    FAuthorList: TABSTable;
    FAuthorListAuthorID: TIntegerField;
    FAuthorListBookID: TIntegerField;
    FAuthorListSerie: TWideStringField;
    FAuthorListTitle: TWideStringField;

    FBooks: TABSTable;
    FBookBookID: TIntegerField;
    FBookLibID: TIntegerField;
    FBookTitle: TWideStringField;
    FBookFullName: TWideStringField;
    FBookSerieID: TIntegerField;
    FBookSeqNumber: TSmallintField;
    FBookDate: TDateField;
    FBookLibRate: TIntegerField;
    FBookLang: TWideStringField;
    FBookFolder: TWideStringField;
    FBookFileName: TWideStringField;
    FBookInsideNo: TIntegerField;
    FBookExt: TWideStringField;
    FBookSize: TIntegerField;
    FBookURI: TWideStringField;
    FBookCode: TSmallintField;
    FBookLocal: TBooleanField;
    FBookDeleted: TBooleanField;
    FBookKeyWords: TWideStringField;

    FSeries: TABSTable;

    FGenres: TABSTable;

    FGenreList: TABSTable;

    FExtra: TABSTable;
  end;

implementation

uses
  SysUtils,
  IOUtils,
  bdeconst,
  unit_Consts;

const
  TEMP_DATABASE = 'TempDB';
  USER_DATABASE = 'UserDB';

type
  TFieldDesc = record
    Name: string;
    DataType: TFieldType;
    Size: Integer;
    Required: Boolean;
  end;

  TIndexDesc = record
    Name: string;
    Fields: string;
    Options: TIndexOptions;
  end;

  TBLOBFieldDesc = record
    Name: string;
    BlobCompressionAlgorithm: TCompressionAlgorithm;
    BlobCompressionMode: Byte;
  end;

const

//-----------------------------------------------------------------------------
//                                 ���������
//-----------------------------------------------------------------------------
//
// Author List
//
AuthorListTableFields: array [1 .. 4] of TFieldDesc = (
  (Name: AUTHOR_ID_FIELD; DataType: ftInteger;    Size: 0;         Required: True),
  (Name: BOOK_ID_FIELD;   DataType: ftInteger;    Size: 0;         Required: True),
  (Name: 'AL_Series';     DataType: ftWideString; Size: INDEXSIZE; Required: False),
  (Name: 'AL_Title';      DataType: ftWideString; Size: INDEXSIZE; Required: False)
);

AuthorListTableIndexes: array [1..3] of TIndexDesc = (
  (Name: 'ID_Index';  Fields: AUTHOR_ID_FIELD + ';' + BOOK_ID_FIELD;   Options: [ixPrimary]),
  (Name: 'BookIndex'; Fields: BOOK_ID_FIELD;                           Options: []),
  (Name: 'AuthIndex'; Fields: AUTHOR_ID_FIELD + ';AL_Series;AL_Title'; Options: [ixCaseInsensitive])   // TODO -oNickR -cDB opt : remove
);

//
//  Authors
//
AuthorsTableFields: array [1 .. 4] of TFieldDesc = (
  (Name: AUTHOR_ID_FIELD;         DataType: ftAutoInc;    Size: 0;   Required: True),
  (Name: AUTHOR_LASTTNAME_FIELD;  DataType: ftWideString; Size: 128; Required: True),
  (Name: AUTHOR_FIRSTNAME_FIELD;  DataType: ftWideString; Size: 128; Required: False),
  (Name: AUTHOR_MIDDLENAME_FIELD; DataType: ftWideString; Size: 128; Required: False)
);

AuthorsTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';      Fields: AUTHOR_ID_FIELD;        Options: [ixPrimary]),
  (Name: 'AlphabetIndex'; Fields: AUTHOR_FULLNAME_FIELDS; Options: [ixCaseInsensitive])
);

//
// Books table
//
BooksTableFields: array [1 .. 19] of TFieldDesc = (
  (Name: BOOK_ID_FIELD;  DataType: ftAutoInc;     Size: 0;   Required: True),
  (Name: LIB_ID_FIELD;   DataType: ftInteger;     Size: 0;   Required: False),
  (Name: 'Title';        DataType: ftWideString;  Size: 150; Required: False),
  (Name: 'FullName';     DataType: ftWideString;  Size: 120; Required: True),
  (Name: SERIE_ID_FIELD; DataType: ftInteger;     Size: 0;   Required: False),
  (Name: 'SeqNumber';    DataType: ftSmallInt;    Size: 0;   Required: False),
  (Name: 'Date';         DataType: ftDate;        Size: 0;   Required: False),
  (Name: 'LibRate';      DataType: ftInteger;     Size: 0;   Required: False),
  (Name: 'Lang';         DataType: ftWideString;  Size: 2;   Required: False),
  (Name: FOLDER_FIELD;   DataType: ftWideString;  Size: MAXFOLDERLENGTH; Required: False),
  (Name: FILENAME_FIELD; DataType: ftWideString;  Size: 170; Required: True),
  (Name: 'InsideNo';     DataType: ftInteger;     Size: 0;   Required: True),
  (Name: 'Ext';          DataType: ftWideString;  Size: 10;  Required: False),
  (Name: 'Size';         DataType: ftInteger;     Size: 0;   Required: False),
  //
  (Name: 'URI';          DataType: ftWideString;  Size: 60;  Required: False),         // TODO -oNickR -cDB opt : remove
  //
  (Name: 'Code';         DataType: ftSmallInt;    Size: 0;   Required: False),
  (Name: 'Local';        DataType: ftBoolean;     Size: 0;   Required: False),
  (Name: 'Deleted';      DataType: ftBoolean;     Size: 0;   Required: False),
  (Name: 'KeyWords';     DataType: ftWideString;  Size: 255; Required: False)
);

BooksTableIndexes: array [1..10] of TIndexDesc = (
  (Name: 'ID_Index';       Fields: BOOK_ID_FIELD;           Options: [ixPrimary]),
  (Name: 'Series_Index';   Fields: SERIE_ID_FIELD + ';SeqNumber';       Options: []),
  (Name: 'Title_Index';    Fields: 'FullName;Title;Deleted;Lang;Date;Local;KeyWords'; Options: [ixCaseInsensitive]),
  (Name: 'File_Index';     Fields: FILENAME_FIELD;          Options: [ixCaseInsensitive]),
  (Name: 'Folder_Index';   Fields: FOLDER_FIELD;            Options: [ixCaseInsensitive]),
  (Name: 'Deleted_Index';  Fields: 'Deleted';               Options: []),
  (Name: 'Date_Index';     Fields: 'Date';                  Options: []),
  (Name: 'Local_Index';    Fields: 'Local';                 Options: []),
  (Name: 'LibID_Index';    Fields: LIB_ID_FIELD;            Options: []),
  (Name: 'KeyWords_Index'; Fields: 'KeyWords';              Options: [ixCaseInsensitive])
);

//
// Series
//
SeriesTableFields: array [1 .. 4] of TFieldDesc = (
  (Name: SERIE_ID_FIELD;   DataType: ftAutoInc;    Size: 0;  Required: True),
  (Name: AUTHOR_ID_FIELD;  DataType: ftInteger;    Size: 0;  Required: True),
  (Name: GENRE_CODE_FIELD; DataType: ftWideString; Size: 20; Required: True),
  (Name: 'S_Title';        DataType: ftWideString; Size: 80; Required: True)
);

SeriesTableIndexes: array [1..4] of TIndexDesc = (
  (Name: 'ID_Index';    Fields: SERIE_ID_FIELD;               Options: [ixPrimary]),
  (Name: 'TiteIndex';   Fields: 'S_Title;' + AUTHOR_ID_FIELD; Options: [ixCaseInsensitive]),
  (Name: 'AuthorIndex'; Fields: AUTHOR_ID_FIELD + ';S_Title'; Options: [ixCaseInsensitive]),
  (Name: 'SeqTitle';    Fields: 'S_Title';                    Options: [ixCaseInsensitive])
);

//
// Genres
//
GenresTableFields: array [1 .. 4] of TFieldDesc = (
  (Name: GENRE_CODE_FIELD; DataType: ftWideString; Size: 20; Required: True),
  (Name: 'ParentCode';     DataType: ftWideString; Size: 20; Required: False),
  (Name: 'FB2Code';        DataType: ftWideString; Size: 20; Required: False),
  (Name: 'GenreAlias';     DataType: ftWideString; Size: 50; Required: True)
);

GenresTableIndexes: array [1..4] of TIndexDesc = (
  (Name: 'ID_Index';     Fields: GENRE_CODE_FIELD;                 Options: [ixPrimary]),
  (Name: 'CodeIndex';    Fields: 'ParentCode;' + GENRE_CODE_FIELD; Options: [ixCaseInsensitive, ixUnique]),
  (Name: 'FB2CodeIndex'; Fields: 'FB2Code';                        Options: [ixCaseInsensitive]),
  (Name: 'AliasIndex';   Fields: 'GenreAlias';                     Options: [])
);

//
// Genre List
//
GenreListTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: GENRE_CODE_FIELD; DataType: ftWideString; Size: 20;        Required: True),
  (Name: BOOK_ID_FIELD;    DataType: ftInteger;    Size: 0;         Required: True),
  (Name: 'GL_Family';      DataType: ftWideString; Size: INDEXSIZE; Required: False),
  (Name: 'GL_Series';      DataType: ftWideString; Size: INDEXSIZE; Required: False),
  (Name: 'GL_Title';       DataType: ftWideString; Size: INDEXSIZE; Required: False)
);

GenreListTableIndexes: array [1..3] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: GENRE_CODE_FIELD + ';' + BOOK_ID_FIELD;   Options: [ixPrimary]),
  (Name: 'BookIndex';  Fields: BOOK_ID_FIELD;                            Options: []),
  (Name: 'GenreIndex'; Fields: 'GenreCode;GL_Family;GL_Series;GL_Title'; Options: [ixCaseInsensitive])
);

//
// Extra
//
ExtraTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: BOOK_ID_FIELD;  DataType: ftInteger;    Size: 0;   Required: True),
  (Name: 'Annotation';   DataType: ftWideMemo;   Size: 0;   Required: False),
  (Name: 'Review';       DataType: ftWideMemo;   Size: 0;   Required: False),
  (Name: 'Rate';         DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'Progress';     DataType: ftInteger;    Size: 0;   Required: False)
);

ExtraTableIndexes: array [1 .. 1] of TIndexDesc = (
  (Name: 'ID_Index';     Fields: BOOK_ID_FIELD;         Options: [ixPrimary])
);

ExtraTableBlobs: array [1 .. 2] of TBLOBFieldDesc = (
  (Name: 'Annotation';   BlobCompressionAlgorithm: caZLIB;   BlobCompressionMode: 5),
  (Name: 'Review';       BlobCompressionAlgorithm: caZLIB;   BlobCompressionMode: 5)
);

// -----------------------------------------------------------------------------
// User.dbsx
// -----------------------------------------------------------------------------
//
// Bases table
//
BasesTableFields: array [1 .. 15] of TFieldDesc = (
  (Name: ID_FIELD;       DataType: ftAutoInc;    Size: 0;   Required: True),
  (Name: 'Name';         DataType: ftWideString; Size: 64;  Required: True),
  (Name: 'RootFolder';   DataType: ftWideString; Size: 128; Required: True),
  (Name: 'DBFileName';   DataType: ftWideString; Size: 128; Required: True),
  (Name: 'Notes';        DataType: ftWideString; Size: 255; Required: False),
  (Name: 'Date';         DataType: ftDate;       Size: 0;   Required: False),
  (Name: 'Version';      DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'Code';         DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'AllowDelete';  DataType: ftBoolean;    Size: 0;   Required: False),
  (Name: 'Settings';     DataType: ftWideMemo;   Size: 0;   Required: False),
  (Name: 'Icon';         DataType: ftBlob;       Size: 0;   Required: False),
  (Name: 'URL';          DataType: ftWideString; Size: 255; Required: False),
  (Name: 'User';         DataType: ftWideString; Size: 50;  Required: False),
  (Name: 'Pass';         DataType: ftWideString; Size: 50;  Required: False),
  (Name: 'Connection';   DataType: ftWideMemo;   Size: 0;   Required: False)
);

BasesTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: ID_FIELD; Options: [ixPrimary]),
  (Name: 'Name_Index'; Fields: 'Name';   Options: [])
);

BasesTableBlobs: array [1 .. 2] of TBLOBFieldDesc = (
  (Name: 'Settings';     BlobCompressionAlgorithm: caZLIB;   BlobCompressionMode: 5),
  (Name: 'Connection';   BlobCompressionAlgorithm: caZLIB;   BlobCompressionMode: 5)
);

//
// Groups List (������: ���������, �����������, � ��������� � �.�.)
//
GroupsListTableFields: array [1..5] of TFieldDesc = (
  (Name: GROUP_ID_FIELD; DataType: ftAutoInc;    Size: 0;   Required: True),
  (Name: 'Name';         DataType: ftWideString; Size: 255; Required: False),
  (Name: 'AllowDelete';  DataType: ftBoolean;    Size: 0;   Required: False),
  (Name: 'Notes';        DataType: ftMemo;       Size: 0;   Required: False),
  (Name: 'Icon';         DataType: ftBlob;       Size: 0;   Required: False)
);

GroupsListTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: GROUP_ID_FIELD;  Options: [ixPrimary]),
  (Name: 'NameIndex';  Fields: 'Name';    Options: [])
);

//
// Book Groups
//
BookGroupsTableFields: array [1 .. 3] of TFieldDesc = (
  (Name: BOOK_ID_FIELD;  DataType: ftInteger;    Size: 0; Required: True),
  (Name: DB_ID_FIELD;    DataType: ftInteger;    Size: 0; Required: True),
  (Name: GROUP_ID_FIELD; DataType: ftInteger;    Size: 0; Required: True)
);

BookGroupsTableIndexes: array [1 .. 2] of TIndexDesc = (
  (Name: 'ID_Index';    Fields: GROUP_ID_FIELD + ';' + BOOK_DB_FIELDS;   Options: [ixPrimary]),
  (Name: 'BookDBIndex'; Fields: BOOK_DB_FIELDS;                          Options: [])
);


//
// Groups table
//
// TODO -oNickR -cDB opt : ��������������� � �������� Books
GroupsTableFields: array [1 .. 25] of TFieldDesc = (
  (Name: BOOK_ID_FIELD;  DataType: ftInteger;    Size: 0;   Required: True),
  (Name: DB_ID_FIELD;    DataType: ftInteger;    Size: 0;   Required: True),
  (Name: LIB_ID_FIELD;   DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'Title';        DataType: ftWideString; Size: 150; Required: False),
  (Name: 'FullName';     DataType: ftWideString; Size: 255; Required: False),
  (Name: SERIE_ID_FIELD; DataType: ftInteger;     Size: 0;   Required: False),
  (Name: 'SeqNumber';    DataType: ftSmallInt;   Size: 0;   Required: False),
  (Name: 'Date';         DataType: ftDate;       Size: 0;   Required: False),
  (Name: 'LibRate';      DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'Lang';         DataType: ftWideString; Size: 2;   Required: False),
  (Name: FOLDER_FIELD;   DataType: ftWideString; Size: 255; Required: False),
  (Name: FILENAME_FIELD; DataType: ftWideString; Size: 255; Required: True),
  (Name: 'InsideNo';     DataType: ftInteger;    Size: 0;   Required: True),
  (Name: 'Ext';          DataType: ftWideString; Size: 10;  Required: False),
  (Name: 'Size';         DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'URI';          DataType: ftWideString; Size: 60;  Required: False),         // TODO -oNickR -cDB opt : remove
  (Name: 'Code';         DataType: ftSmallInt;   Size: 0;   Required: False),
  (Name: 'Local';        DataType: ftBoolean;    Size: 0;   Required: False),
  (Name: 'Deleted';      DataType: ftBoolean;    Size: 0;   Required: False),
  (Name: 'KeyWords';     DataType: ftWideString; Size: 255; Required: False),

  //
  // ������ �� ������� Extra
  //
  (Name: 'Review';       DataType: ftWideMemo;   Size: 0;   Required: False),
  (Name: 'Rate';         DataType: ftInteger;    Size: 0;   Required: False),
  (Name: 'Progress';     DataType: ftSmallInt;   Size: 0;   Required: False),

  //
  // ������ �� ������ ������
  //
  (Name: 'Genres';       DataType: ftWideString; Size: 128; Required: False),
  (Name: 'Series';       DataType: ftWideString; Size: 128; Required: False)
);

GroupsTableIndexes: array [1 .. 3] of TIndexDesc = (
  (Name: 'ID_Index';       Fields: BOOK_DB_FIELDS;          Options: [ixPrimary]),
  (Name: 'FullName_Index'; Fields: 'FullName;Series;Title'; Options: []),
  (Name: 'File_Index';     Fields: FILENAME_FIELD;          Options: [])
);

GroupBooksTableBlobs: array [1 .. 1] of TBLOBFieldDesc = (
  (Name: 'Review';     BlobCompressionAlgorithm: caZLIB;   BlobCompressionMode: 5)
);

// ------------------------------------------------------------------------------

procedure CreateTable(
  ADatabase: TABSDatabase;
  const TableName: string;
  const FieldDesc: array of TFieldDesc;
  const IndexDesc: array of TIndexDesc;
  const BLOBDesc: array of TBLOBFieldDesc
  );
var
  TempTable: TABSTable;
  i: Integer;
  f: TABSAdvFieldDef;
begin
  TempTable := TABSTable.Create(ADatabase);
  try
    TempTable.TableName := TableName;

    for i := 0 to High(FieldDesc) do
      TempTable.FieldDefs.Add(FieldDesc[i].Name, FieldDesc[i].DataType, FieldDesc[i].Size, FieldDesc[i].Required);

    for i := 0 to High(IndexDesc) do
      TempTable.IndexDefs.Add(IndexDesc[i].Name, IndexDesc[i].Fields, IndexDesc[i].Options);

    TempTable.CreateTable;

    if Length(BLOBDesc) > 0 then
    begin
      TempTable.Open;
      TempTable.Close;

      for i := 0 to High(BLOBDesc) do
      begin
        f := TempTable.RestructureFieldDefs.Find(BLOBDesc[i].Name);
        if Assigned(f) then
        begin
          f.BlobCompressionAlgorithm := BLOBDesc[i].BlobCompressionAlgorithm;
          f.BlobCompressionMode := BLOBDesc[i].BlobCompressionMode;
        end;
      end;

      TempTable.RestructureTable;
    end;
  finally
    TempTable.Free;
  end;
end;

{ TMHLLibrary }

procedure TMHLLibrary.CheckActive;
begin
  if not Active then
    DatabaseError(SDatabaseClosed, Self);
end;

procedure TMHLLibrary.CheckInactive;
begin
  if Active then
    DatabaseError(SDatabaseOpen, Self);
end;

constructor TMHLLibrary.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDatabase := TABSDatabase.Create(Self);
  FDatabase.DatabaseName := TEMP_DATABASE;
  FDatabase.MaxConnections := 5;
  FDatabase.PageSize := 65535;
  FDatabase.PageCountInExtent := 16;

  FAuthors := TABSTable.Create(FDatabase);
  FAuthors.TableName := 'Authors';

  FAuthorList := TABSTable.Create(FDatabase);
  FAuthorList.TableName := 'Author_list';

  FBooks := TABSTable.Create(FDatabase);
  FBooks.TableName := 'Books';

  FSeries := TABSTable.Create(FDatabase);
  FSeries.TableName := 'Series';

  FGenres := TABSTable.Create(FDatabase);
  FGenres.TableName := 'Genres';

  FGenreList := TABSTable.Create(FDatabase);
  FGenreList.TableName := 'Genre_list';

  FExtra := TABSTable.Create(FDatabase);
  FExtra.TableName := 'Extra';
end;

destructor TMHLLibrary.Destroy;
begin
  Active := False;
  inherited Destroy;
end;

function TMHLLibrary.GetActive: Boolean;
begin
  Result := FDatabase.Connected;
end;

procedure TMHLLibrary.SetActive(const Value: Boolean);
begin
  FDatabase.Connected := Value;

  FAuthors.Active := Value;
  FAuthorList.Active := Value;
  FBooks.Active := Value;
  FSeries.Active := Value;
  FGenres.Active := Value;
  FGenreList.Active := Value;
  FExtra.Active := Value;

  if Value then
  begin
    FAuthorID := FAuthors.FindField(AUTHOR_ID_FIELD) as TIntegerField;
    FAuthorLastName := FAuthors.FindField(AUTHOR_LASTTNAME_FIELD) as TWideStringField;
    FAuthorFirstName := FAuthors.FindField(AUTHOR_FIRSTNAME_FIELD) as TWideStringField;
    FAuthorMiddleName := FAuthors.FindField(AUTHOR_MIDDLENAME_FIELD) as TWideStringField;

    FAuthorListAuthorID := FAuthorList.FindField(AUTHOR_ID_FIELD) as TIntegerField;
    FAuthorListBookID := FAuthorList.FindField(BOOK_ID_FIELD) as TIntegerField;
    FAuthorListSerie := FAuthorList.FindField('AL_Series') as TWideStringField;
    FAuthorListTitle := FAuthorList.FindField('AL_Title') as TWideStringField;

    FBookBookID := FBooks.FindField(BOOK_ID_FIELD) as TIntegerField;
    FBookLibID := FBooks.FindField(LIB_ID_FIELD) as TIntegerField;
    FBookTitle := FBooks.FindField('Title') as TWideStringField;
    FBookFullName := FBooks.FindField('FullName') as TWideStringField;
    FBookSerieID := FBooks.FindField(SERIE_ID_FIELD) as TIntegerField;
    FBookSeqNumber := FBooks.FindField('SeqNumber') as TSmallintField;
    FBookDate := FBooks.FindField('Date') as TDateField;
    FBookLibRate := FBooks.FindField('LibRate') as TIntegerField;
    FBookLang := FBooks.FindField('Lang') as TWideStringField;
    FBookFolder := FBooks.FindField(FOLDER_FIELD) as TWideStringField;
    FBookFileName := FBooks.FindField(FILENAME_FIELD) as TWideStringField;
    FBookInsideNo := FBooks.FindField('InsideNo') as TIntegerField;
    FBookExt := FBooks.FindField('Ext') as TWideStringField;
    FBookSize := FBooks.FindField('Size') as TIntegerField;
    FBookURI := FBooks.FindField('URI') as TWideStringField;
    FBookCode := FBooks.FindField('Code') as TSmallintField;
    FBookLocal := FBooks.FindField('Local') as TBooleanField;
    FBookDeleted := FBooks.FindField('Deleted') as TBooleanField;
    FBookKeyWords := FBooks.FindField('KeyWords') as TWideStringField;
  end
  else
  begin
    FAuthorID := nil;
    FAuthorLastName := nil;
    FAuthorFirstName := nil;
    FAuthorMiddleName := nil;

    FAuthorListAuthorID := nil;
    FAuthorListBookID := nil;
    FAuthorListSerie := nil;
    FAuthorListTitle := nil;

    FBookBookID := nil;
    FBookLibID := nil;
    FBookTitle := nil;
    FBookFullName := nil;
    FBookSerieID := nil;
    FBookSeqNumber := nil;
    FBookDate := nil;
    FBookLibRate := nil;
    FBookLang := nil;
    FBookFolder := nil;
    FBookFileName := nil;
    FBookInsideNo := nil;
    FBookExt := nil;
    FBookSize := nil;
    FBookURI := nil;
    FBookCode := nil;
    FBookLocal := nil;
    FBookDeleted := nil;
    FBookKeyWords := nil;
  end;
end;

function TMHLLibrary.GetDatabaseFileName: string;
begin
  Result := FDatabase.DatabaseFileName;
end;

procedure TMHLLibrary.SetDatabaseFileName(const Value: string);
begin
  CheckInactive;
  FDatabase.DatabaseFileName := Value;
end;

class procedure TMHLLibrary.CreateSystemTables(const DBFile: string);
var
  ADatabase: TABSDatabase;
  Groups: TABSTable;
begin
  ADatabase := TABSDatabase.Create(nil);
  try
    ADatabase.DatabaseFileName := DBFile;
    ADatabase.DatabaseName := USER_DATABASE;
    ADatabase.MaxConnections := 5;
    ADatabase.CreateDatabase;

    CreateTable(ADatabase, 'Bases',      BasesTableFields,      BasesTableIndexes,      BasesTableBlobs);
    CreateTable(ADatabase, 'Groups',     GroupsListTableFields, GroupsListTableIndexes, []);
    CreateTable(ADatabase, 'BookGroups', BookGroupsTableFields, BookGroupsTableIndexes, GroupBooksTableBlobs);
    CreateTable(ADatabase, 'Books',      GroupsTableFields,     GroupsTableIndexes,     []);
    ADatabase.Connected := False;

    //
    // ������� ��������� ������
    //
    Groups := TABSTable.Create(ADatabase);
    Groups.TableName := 'Groups';
    Groups.Active := True;

    Groups.Insert;
    Groups['Name'] := '���������';
    Groups['AllowDelete'] := False;
    Groups.Post;

    Groups.Insert;
    Groups['Name'] := '� ���������';
    Groups['AllowDelete'] := False;
    Groups.Post;
  finally
    ADatabase.Free;
  end;
end;

procedure TMHLLibrary.CreateCollectionTables(const DBFile: string; const GenresFileName: string);
begin
  CheckInactive;

  DatabaseFileName := DBFile;
  FDatabase.CreateDatabase;

  //
  // �������� �������
  //
  CreateTable(FDatabase, 'Books',       BooksTableFields,      BooksTableIndexes,      []);
  CreateTable(FDatabase, 'Authors',     AuthorsTableFields,    AuthorsTableIndexes,    []);
  CreateTable(FDatabase, 'Series',      SeriesTableFields,     SeriesTableIndexes,     []);
  CreateTable(FDatabase, 'Genres',      GenresTableFields,     GenresTableIndexes,     []);
  CreateTable(FDatabase, 'Genre_List',  GenreListTableFields,  GenreListTableIndexes,  []);
  CreateTable(FDatabase, 'Author_List', AuthorListTableFields, AuthorListTableIndexes, []);
  CreateTable(FDatabase, 'Extra',       ExtraTableFields,      ExtraTableIndexes,      ExtraTableBlobs);

  Active := True;

  //
  // �������� ������� ������
  //
  LoadGenres(GenresFileName);

  //
  // �������� ��������� �����
  //
  FSeries.Insert;
  FSeries.FieldByName('S_Title').AsString := NO_SERIES_TITLE;
  FSeries[GENRE_CODE_FIELD] := '0';
  FSeries[AUTHOR_ID_FIELD] := 0;
  FSeries.Post;
end;

procedure TMHLLibrary.LoadGenres(const GenresFileName: string);
var
  FS: TStringList;
  i: Integer;
  p: Integer;
  S: string;
  ParentCode: String;
  Code: String;
  FB2Code: String;
begin
  CheckActive;

  FS := TStringList.Create;
  try
    FS.LoadFromFile(GenresFileName, TEncoding.UTF8);

    for i := 0 to FS.Count - 1 do
    begin
      S := FS[i];
      //
      // ��������� ������ ������
      //
      if S = '' then
        Continue;

      //
      // ... � �����������
      //
      if S[1] = '#' then
        Continue;

      //
      // ������ ���� ������ � ��������� �������
      // -------------------------------------
      // 0.1 ���������� (������� ���������� � �������)
      // 0.2 ��������� � ��������
      // ...
      // 0.1.0 sf;������� ����������
      // 0.1.1 sf_history;�������������� �������
      // ...
      // -------------------------------------

      //
      // �������� ��� (0.1)
      //
      p := AnsiPos(' ', S);
      if 0 = p then
        Continue;
      Code := Copy(S, 1, p - 1);
      Delete(S, 1, p);

      //
      // � ��� ������������� �������� (0)
      //
      p := LastDelimiter('.', Code);
      if 0 = p then
        Continue;
      ParentCode := Copy(Code, 1, p - 1);

      //
      // fb2 ���. ����� �������������! (sf)
      //
      FB2Code := '';
      p := AnsiPos(';', S);
      if 0 <> p then
      begin
        FB2Code := Copy(S, 1, p - 1);
        Delete(S, 1, p);
      end;

      //
      // ���� ����� ���� ��� ���������� => ��������� ���
      //
      { TODO -oNickR : ����� ����� ��������� � ��������� ����? }
      if FGenres.Locate(GENRE_CODE_FIELD, Code, []) then
        Continue;

      //
      // ��� ������ => ��������� � ����
      //
      FGenres.Insert;
      FGenres.FieldByName(GENRE_CODE_FIELD).AsString := Code;
      FGenres['ParentCode'] := ParentCode;
      FGenres['FB2Code'] := FB2Code;
      FGenres['GenreAlias'] := S;
      FGenres.Post;
    end;
  finally
    FS.Free;
  end;
end;

procedure TMHLLibrary.ReloadDefaultGenres(const FileName: string);
begin
  CheckActive;

  //
  // ��������� ������� Genres
  //
  FGenres.Active := False;
  FGenres.EmptyTable;
  FGenres.Active := True;

  LoadGenres(FileName);
end;

function TMHLLibrary.GetGenreAlias(const FB2Code: string): string;
begin
  FGenres.Locate('FB2Code', FB2Code, []);
  Result := FGenres.FieldByName('GenreAlias').AsWideString;
end;

function TMHLLibrary.GetTopGenreAlias(const FB2Code: string): string;
var
  Code: string;
  p: Integer;
begin
  FGenres.Locate('FB2Code', FB2Code, []);
  Code := FGenres.FieldByName(GENRE_CODE_FIELD).AsWideString;

  Delete(Code, 1, 2); // "0."
  p := Pos('.', Code);
  Code := '0.' + Copy(Code, 1, p - 1);

  FGenres.Locate(GENRE_CODE_FIELD, Code, []);
  Result := FGenres.FieldByName('GenreAlias').AsWideString;
end;

function TMHLLibrary.CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean;
var
  S: string;
begin
  CheckActive;

  if ZipFolder then
    Result := FBooks.Locate(FOLDER_FIELD, FileName, [loCaseInsensitive])
  else
  begin
    if FullNameSearch then
      S := ExtractFileName(FileName)
    else
      S := TPath.GetFileNameWithoutExtension(FileName);
    Result := FBooks.Locate(FILENAME_FIELD, S, [loCaseInsensitive]);
  end;
end;

function TMHLLibrary.InsertBook(BookRecord: TBookRecord; CheckFileName, FullCheck: Boolean): Integer;
var
  i: Integer;
  ASeqNumber: Integer;
  Genre: TGenreData;
  Author: TAuthorRecord;

  Res: Boolean;

begin
  Result := 0;
  CheckActive;

  if BookRecord.FileName = '' then
    Exit;

  BookRecord.Normalize;

  //
  // �������� ������������� �������
  //
  Assert(BookRecord.AuthorCount > 0);
  for i := 0 to BookRecord.AuthorCount - 1 do
  begin
    if not FAuthors.Locate(AUTHOR_FULLNAME_FIELDS, VarArrayOf([BookRecord.Authors[i].LastName, BookRecord.Authors[i].FirstName, BookRecord.Authors[i].MiddleName]), [loCaseInsensitive]) then
    begin
      FAuthors.Insert;
      FAuthorLastName.Value := BookRecord.Authors[i].LastName;
      FAuthorFirstName.Value := BookRecord.Authors[i].FirstName;
      FAuthorMiddleName.Value := BookRecord.Authors[i].MiddleName;
      FAuthors.Post;
    end;

    //
    // � �������� ID-��
    //
    BookRecord.Authors[i].AuthorID := FAuthorID.Value;
  end;

  //
  // ���������� ��� �����
  //
  Assert(BookRecord.GenreCount > 0);
  for i := 0 to BookRecord.GenreCount - 1 do
  begin
    //
    // ���� fb2 ��� ������, ��������� ��� � ������������� ���
    //
    if BookRecord.Genres[i].FB2GenreCode <> '' then
    begin
      //
      // ����� fb2-��� ����� => �������� ���������� ���
      //
      if FGenres.Locate('FB2Code', BookRecord.Genres[i].FB2GenreCode, [loCaseInsensitive]) then
        BookRecord.Genres[i].GenreCode := FGenres.FieldByName(GENRE_CODE_FIELD).AsString
      else
        //
        // fb2-��� ����������� - ��� � �������
        //
        BookRecord.Genres[i].GenreCode := UNKNOWN_GENRE_CODE;
    end
    else
    //
    // ���� �� ������ fb2-���, ��������� ������� ����������� ����.
    // ���� ���������� ��� ���������� ��� �� ������ => "��� � �������"
    //
    if
      (BookRecord.Genres[i].GenreCode = '') or                         // ���������� ��� �� ������
      (not FGenres.Locate(GENRE_CODE_FIELD, BookRecord.Genres[i].GenreCode, [loCaseInsensitive]))  // ���������� ��� ����������
    then
      BookRecord.Genres[i].GenreCode := UNKNOWN_GENRE_CODE;
  end;

  //
  // �������� ������������� �����
  // DONE -oNickR : ����� ����� ��������� �� ������ Title, �� � AuthID?
  // � � � ����� ����� ����� ���� ����� ������ �������, �� _����_ ������� ��� ����
  // ��������, �� ������ ������ �������� � ����� �������.
  //
  // TODO -cRelease2.0 : ��������� ��������� ����� ��� ������� ������, � ������������ �� �����������
  //
  if not FSeries.Locate('S_Title', BookRecord.Serie, [loCaseInsensitive]) then
  begin
    FSeries.Append;
    FSeries.FieldByName(GENRE_CODE_FIELD).AsString := BookRecord.Genres[0].GenreCode;
    FSeries.FieldByName(AUTHOR_ID_FIELD).AsInteger := BookRecord.Authors[0].AuthorID;
    FSeries.FieldByName('S_Title').AsString := BookRecord.Serie;
    FSeries.Post;
  end;

  //
  // ���������� �������� ���������� � �����
  //
  if CheckFileName then
    if FullCheck then
      Res := FBooks.Locate('Folder;FileName', VarArrayOf([BookRecord.Folder, BookRecord.FileName]), [loCaseInsensitive])
    else
      Res := FBooks.Locate(FILENAME_FIELD, BookRecord.FileName, [loCaseInsensitive])
    else
      Res := False;

  if not Res then
  begin
    ASeqNumber := BookRecord.SeqNumber;
    if ASeqNumber > 5000 then
      ASeqNumber := 0;

    FBooks.Insert;
    FBookLibID.Value := BookRecord.LibID;
    FBookTitle.Value := BookRecord.Title;
    FBookFullName.Value := AnsiUpperCase(BookRecord.Authors[0].GetFullName); // ���� ������ ��� ������!
    FBookSerieID.Value := FSeries.FieldByName(SERIE_ID_FIELD).AsInteger;
    FBookSeqNumber.Value := ASeqNumber;
    FBookDate.Value := BookRecord.Date;
    FBookLibRate.Value := BookRecord.LibRate;
    FBookLang.Value := BookRecord.Lang;
    FBookFolder.Value := BookRecord.Folder;
    FBookFileName.Value := BookRecord.FileName;
    FBookInsideNo.Value := BookRecord.InsideNo;
    FBookExt.Value := BookRecord.FileExt;
    FBookSize.Value := BookRecord.Size;
    FBookURI.Value := BookRecord.URI;
    FBookCode.Value := BookRecord.Code;
    FBookLocal.Value := BookRecord.Local;
    FBookDeleted.Value := BookRecord.Deleted;
    FBookKeyWords.Value := BookRecord.KeyWords;
    FBooks.Post;

    for Genre in BookRecord.Genres do
    begin
      FGenreList.Append;
      try
        FGenreList.FieldByName(BOOK_ID_FIELD).AsInteger := FBookBookID.Value;
        FGenreList.FieldByName(GENRE_CODE_FIELD).AsString := Genre.GenreCode;
        //
        // ������������ ��������� ����� (�������������� �� ������ 10-�� ��������)
        //
        FGenreList.FieldByName('GL_Family').AsString := Copy(BookRecord.Authors[0].GetFullName, 1, INDEXSIZE);
        FGenreList.FieldByName('GL_Title').AsString := Copy(BookRecord.Title, 1, INDEXSIZE);
        FGenreList.FieldByName('GL_Series').AsString := Copy(BookRecord.Serie, 1, INDEXSIZE);
        FGenreList.Post;
      except
        FGenreList.Cancel;
      end;
    end;

    for Author in BookRecord.Authors do
    begin
      FAuthorList.Append;
      try
        FAuthorListAuthorID.Value := Author.AuthorID;
        FAuthorListBookID.Value := FBookBookID.Value;
        //
        // ������������ ��������� ����� (�������������� �� ������ 10-�� ��������)
        //
        FAuthorListTitle.Value := Copy(BookRecord.Title, 1, INDEXSIZE);
        FAuthorListSerie.Value := Copy(BookRecord.Serie, 1, INDEXSIZE);

        FAuthorList.Post;
      except
        FAuthorList.Cancel;
      end;
    end;

    if (BookRecord.Annotation <> '') or (BookRecord.Rate <> 0) or (BookRecord.Progress <> 0) then
    begin
      FExtra.Append;
      FExtra.FieldByName(BOOK_ID_FIELD).AsInteger := FBookBookID.Value;
      FExtra.FieldByName('Annotation').AsString := BookRecord.Annotation;
      FExtra.FieldByName('Rate').AsInteger := BookRecord.Rate;
      FExtra.FieldByName('Progress').AsInteger := BookRecord.Progress;
      FExtra.Post;
    end;

    Result := FBookBookID.Value;
  end;
end;

procedure TMHLLibrary.DeleteBook(BookID: Integer; ClearExtra: Boolean = True);
var
  SerieID: Integer;
begin
  CheckActive;

  if FBooks.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    SerieID := FBooks[SERIE_ID_FIELD];
    FBooks.Delete;

    { TODO -oNickR : �������� ��� ������ �� DELETE FROM query }

    while FGenreList.Locate(BOOK_ID_FIELD, BookID, []) do
      FGenreList.Delete;
    while FAuthorList.Locate(BOOK_ID_FIELD, BookID, []) do
      FAuthorList.Delete;

    //
    // ���� ����� ������� � ����� (SerieID <> 1) ��������, �� ���� �� ������� �����.
    //
    if SerieID <> 1 then
    begin
      if not FBooks.Locate(SERIE_ID_FIELD, SerieID, []) then
      begin
        //
        // ������ ���� �� ���� ����� ��� => ������ �����
        //
        FSeries.Locate(SERIE_ID_FIELD, SerieID, []);
        FSeries.Delete;
      end;
    end;

    // ������� �� Extra
    if ClearExtra and FExtra.Locate(BOOK_ID_FIELD, BookID, []) then
      FExtra.Delete;

    //
    // � ������� ������ ������ ���� ���� ���� �����.
    // TODO -oNickR -cUsability : ��������, ����� �������� ��� ���������� � ������� �������� �������, ���� ������� ��� � ����������
    //
    FAuthors.First;
    while not FAuthors.Eof do
    begin
      if FAuthorList.Locate(AUTHOR_ID_FIELD, FAuthorID.Value, []) then
        FAuthors.Next
      else
        FAuthors.Delete;
    end;

    { TODO 5 -oNickR -cBug : ���������� ������� ����� �� ����� }
  end;
end;

procedure TMHLLibrary.AddBookGenre(BookID: Integer; const GenreCode: string);
begin
  CheckActive;

  if FBooks.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    FGenreList.Insert;
    FGenreList[BOOK_ID_FIELD] := BookID;
    FGenreList[GENRE_CODE_FIELD] := GenreCode;
    FGenreList['GL_Family'] := Copy(FBooks['FullName'], 1, INDEXSIZE);
    FGenreList['GL_Title'] := Copy(FBooks['Title'], 1, INDEXSIZE);

    if FSeries.Locate(SERIE_ID_FIELD, FBooks[SERIE_ID_FIELD], []) then
      FGenreList['GL_Series'] := Copy(FSeries.FieldByName('S_Title').AsString, 1, INDEXSIZE);
    FGenreList.Post;
  end;
end;

procedure TMHLLibrary.CleanBookGenres(BookID: Integer);
begin
  CheckActive;

  while FGenreList.Locate(BOOK_ID_FIELD, BookID, []) do
    FGenreList.Delete;
end;

procedure TMHLLibrary.CorrectExtra(OldID, NewID: Integer);
begin
  ///FExtra.MasterSource := nil;
  if FExtra.Locate(BOOK_ID_FIELD, OldID, []) then
  begin
    FExtra.Edit;
    FExtra[BOOK_ID_FIELD] := NewID;
    FExtra.Post;
  end;
end;

procedure TMHLLibrary.GetSeries(SeriesList: TStrings);
begin
  FSeries.First;
  while not FSeries.Eof do
  begin
    if FSeries[SERIE_ID_FIELD] <> 1 then
      SeriesList.Add(FSeries.FieldByName('S_Title').AsString);
    FSeries.Next;
  end;
end;

procedure TMHLLibrary.BeginBulkOperation;
begin
  CheckActive;
  Assert(not FDatabase.InTransaction);

  FDatabase.StartTransaction;
end;

procedure TMHLLibrary.EndBulkOperation(Commit: Boolean = True);
begin
  CheckActive;
  Assert(FDatabase.InTransaction);

  if Commit then
    FDatabase.Commit(False)
  else
    FDatabase.Rollback;
end;

{ TAbsTableHelper }

constructor TABSTableHelper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //
  // TABSDatabase �� ����������� �� TDatabase. ��� ���������, ����������� TDataset-�
  // (�������� ������ TAbsTable) �� ����� ���������� �������� "DatabaseName".
  // ����������� ��� ���������.
  //
  if AOwner is TABSDatabase then
    DatabaseName := TABSDatabase(AOwner).DatabaseName;
end;

end.
