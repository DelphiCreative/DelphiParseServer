unit FMX.Helpers;

interface

uses
  FMX.StdCtrls, FMX.Menus, FMX.Dialogs, FMX.Objects, System.SysUtils, System.JSON;

type
  TImageHelper = class helper for TImage
  private
    procedure LoadImageFromFileDialog;
    procedure RemoveImage;
    procedure PopupMenuClick(Sender: TObject);
  public
    procedure EnableImagePopup;
  end;

type
  TStringHelper = record helper for string
    function FindJsonValue(const AKey: string): string;
    function JsonFormat :string;
  end;

implementation

procedure TImageHelper.EnableImagePopup;
var
  PopupMenu: TPopupMenu;
  MenuItemLoadImage, MenuItemRemoveImage: TMenuItem;
begin
  PopupMenu := TPopupMenu.Create(Self);

  MenuItemLoadImage := TMenuItem.Create(PopupMenu);
  MenuItemLoadImage.Text := 'Carregar Imagem';
  MenuItemLoadImage.OnClick := PopupMenuClick;
  MenuItemLoadImage.Tag := 0;
  PopupMenu.AddObject(MenuItemLoadImage);

  MenuItemRemoveImage := TMenuItem.Create(PopupMenu);
  MenuItemRemoveImage.Text := 'Remover Imagem';
  MenuItemRemoveImage.OnClick := PopupMenuClick;
  MenuItemRemoveImage.Tag := 1;
  PopupMenu.AddObject(MenuItemRemoveImage);

  Self.AddObject(PopupMenu);
  Self.PopupMenu :=  PopupMenu

end;

procedure TImageHelper.LoadImageFromFileDialog;
var
  OpenFileDialog: TOpenDialog;
begin
  OpenFileDialog := TOpenDialog.Create(nil);
  try
    OpenFileDialog.Filter := 'Imagens|*.jpg;*.jpeg;*.png;*.bmp';
    if OpenFileDialog.Execute then
    begin
      try
        Self.Bitmap.LoadFromFile(OpenFileDialog.FileName);
        Self.Hint := OpenFileDialog.FileName;
      except
        on E: Exception do
          ShowMessage('Erro ao carregar a imagem: ' + E.Message);
      end;
    end;
  finally
    OpenFileDialog.Free;
  end;
end;

procedure TImageHelper.RemoveImage;
begin
  Self.Hint := '';
  Self.Bitmap := nil;
end;

procedure TImageHelper.PopupMenuClick(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
    0: LoadImageFromFileDialog;
    1: RemoveImage;
  end;
end;

{ TStringHelper }

function TStringHelper.FindJsonValue(const AKey: string): string;
var
  StartPos, EndPos: Integer;
  KeyStartPos, KeyEndPos: Integer;
  jsonObject: TJSONObject;
  resultObject: TJSONObject;
begin
  Result := '';

  try
    jsonObject := TJSONObject.ParseJSONValue(Self) as TJSONObject;

    if Assigned(jsonObject) then
    begin
      resultObject := jsonObject.GetValue('result') as TJSONObject;
      if Assigned(resultObject) then
      begin
        Result := resultObject.GetValue(AKey).Value;
      end;
    end;
  finally
    jsonObject.Free;
  end;

end;

function TStringHelper.JsonFormat :string;
var
   jsonObject: TJSONObject;
begin
   try
      try
        jsonObject := TJSONObject.ParseJSONValue(Self) as TJSONObject;
        Result := jsonObject.Format;
      except
        Result := Self;
      end;
   finally
     jsonObject.Free;
   end;
end;


end.

