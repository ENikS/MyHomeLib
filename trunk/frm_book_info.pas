
{******************************************************************************}
{                                                                              }
{                                 MyHomeLib                                    }
{                                                                              }
{                                Version 0.9                                   }
{                                20.08.2008                                    }
{                    Copyright (c) Aleksey Penkov  alex.penkov@gmail.com       }
{                                                                              }
{******************************************************************************}


unit frm_book_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, ExtCtrls, RzPanel, RzButton,
  StdCtrls, RzLabel, RzEdit, ComCtrls;

type
  TfrmBookDetails = class(TForm)
    RzPanel1: TRzPanel;
    Img: TImage;
    XML: TXMLDocument;
    RzBitBtn1: TRzBitBtn;
    mmShort: TMemo;
    mmInfo: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RzBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowBookInfo(FN: string);
    { Public declarations }
  end;

var
  frmBookDetails: TfrmBookDetails;

implementation

uses FictionBook_21, globals, unit_Settings;

{$R *.dfm}

procedure TfrmBookDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=27 then Close;
end;

procedure TfrmBookDetails.RzBitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBookDetails.ShowBookInfo(FN:string);
var
  book:IXMLFictionBook;
  i,p:integer;
  S,outStr:string;
  F:TextFile;
  CoverID:String;
begin
  Img.Picture.Bitmap.Canvas.FrameRect(Img.ClientRect);
  mmInfo.Lines.Clear;
  mmShort.Lines.Clear;
  try
    XML.LoadFromFile(FN);
    book:=GetFictionbook(XML);

    CoverID:=book.Description.TitleInfo.Coverpage.XML;
    p:=pos('"#',CoverID);
    Delete(CoverId,1,p+1);
    p:=pos('"',CoverID);
    CoverID:=Copy(CoverID,1,p-1);
    for i:=0 to book.Binary.Count-1 do
    begin
      if Book.Binary.Items[i].Id=CoverID then
      begin
        S:=Book.Binary.Items[i].Text;
        outStr:=DecodeBase64(S);
        AssignFile(F,Settings.TempPath + CoverID);
        Rewrite(F);
        Write(F,outStr);
        CloseFile(F);
      end;
    end;
    Img.Picture.LoadFromFile(Settings.TempPath + CoverID);

    with Book.Description.Titleinfo do
    begin
      mmInfo.Lines.Add('Description:');
      if Author.Count>0 then
        mmInfo.Lines.Add(Author[0].Lastname.Text+' '+Author[0].Firstname.Text);
      mmInfo.Lines.Add(Booktitle.Text);
      if Genre.Count>0 then mmInfo.Lines.Add('����: '+Genre[0]);;
      if Sequence.Count>0 then
      begin
        mmInfo.Lines.Add('�����: '+Sequence[0].Name);
        mmInfo.Lines.Add('�����: '+IntToStr(Sequence[0].Number));
      end;

      mmShort.Lines.Add(Annotation.P.OnlyText);

      mmInfo.Lines.Add('PublishInfo:');
      mmInfo.Lines.Add('��������: '+Book.Description.Publishinfo.Publisher.Text);
      mmInfo.Lines.Add('�����: '+Book.Description.Publishinfo.City.Text);
      mmInfo.Lines.Add('���: '+Book.Description.Publishinfo.Year);
      mmInfo.Lines.Add('ISBN: '+Book.Description.Publishinfo.Isbn.Text);
      mmInfo.Lines.Add('DocumentInfo (OCR):');
      mmInfo.Lines.Add('������: ');
      for I := 0 to Book.Description.Documentinfo.Author.Count - 1 do
        with Book.Description.Documentinfo.Author.Items[i] do
            mmInfo.Lines.Add(Firstname.Text + ' ' +Lastname.Text + '(' + NickName.Text + ')');
      mmInfo.Lines.Add('���������: '+Book.Description.Documentinfo.Programused.Text);
      mmInfo.Lines.Add('����: '+Book.Description.Documentinfo.Date.Text);
      mmInfo.Lines.Add('ID: '+Book.Description.Documentinfo.ID);
      mmInfo.Lines.Add('Version: '+Book.Description.Documentinfo.Version);
      mmInfo.Lines.Add('History: '+Book.Description.Documentinfo.History.P.OnlyText);
    end;
  except
  end;
end;


end.
