unit FMX.Helpers;

interface

uses
  FMX.StdCtrls, FMX.Menus, FMX.Dialogs, FMX.Objects, System.SysUtils;

type
  TImageHelper = class helper for TImage
  private
    procedure LoadImageFromFileDialog;
    procedure RemoveImage;
    procedure PopupMenuClick(Sender: TObject);
  public
    procedure EnableImagePopup;
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

end.

