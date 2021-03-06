(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Nick Rymanov    nrymanov@gmail.com
  *                     Aleksey Penkov  alex.penkov@gmail.com
  * Created             22.02.2010
  * Description         
  *
  * $Id$
  *
  * History
  * NickR 02.03.2010    ��� ����������������
  * NickR 08.04.2010    ������ �������� �����������
  *
  ****************************************************************************** *)

unit unit_Export;

interface

procedure Export2INPX(const CollectionID: Integer; const FileName: string);

implementation

uses
  Forms,
  unit_ExportINPXThread,
  frm_ExportProgressForm;

procedure Export2INPX(const CollectionID: Integer; const FileName: string);
var
  worker: TExport2INPXThread;
  frmProgress: TExportProgressForm;
begin
  worker := TExport2INPXThread.Create(CollectionID, FileName);
  try
    frmProgress := TExportProgressForm.Create(Application);
    try
      frmProgress.WorkerThread := worker;
      frmProgress.ShowModal;
    finally
      frmProgress.Free;
    end;
  finally
    worker.Free;
  end;
end;

end.

