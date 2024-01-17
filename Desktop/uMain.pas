unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, Skia, FMX.Skia, System.Generics.Collections, System.JSON,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.EditBox,
  FMX.NumberBox, FMX.Functions, FMX.Effects, FMX.Menus, FMX.ComboEdit;

type
  TForm1 = class(TForm)
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    RoundRect2: TRoundRect;
    SkSvg2: TSkSvg;
    SkLabel2: TSkLabel;
    RoundRect3: TRoundRect;
    SkSvg3: TSkSvg;
    SkLabel3: TSkLabel;
    RoundRect5: TRoundRect;
    SkSvg4: TSkSvg;
    SkLabel4: TSkLabel;
    RoundRect4: TRoundRect;
    SkSvg5: TSkSvg;
    SkLabel5: TSkLabel;
    RoundRect6: TRoundRect;
    SkSvg6: TSkSvg;
    SkLabel6: TSkLabel;
    RoundRect1: TRoundRect;
    SkSvg7: TSkSvg;
    SkLabel7: TSkLabel;
    rctTop: TRoundRect;
    rctBotton: TRoundRect;
    RoundRect7: TRoundRect;
    RoundRect8: TRoundRect;
    SkSvg1: TSkSvg;
    SkLabel1: TSkLabel;
    RoundRect9: TRoundRect;
    SkSvg8: TSkSvg;
    SkLabel8: TSkLabel;
    rctMenuDining: TRoundRect;
    lblMenuDining: TSkLabel;
    imgMenuDining: TImage;
    TabControl1: TTabControl;
    StyleBook1: TStyleBook;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Layout3: TLayout;
    lblName: TLabel;
    edtName: TEdit;
    lblDescription: TLabel;
    lblPrice: TLabel;
    lblCategory: TLabel;
    cmbCategory: TComboBox;
    chkAvailability: TCheckBox;
    chkHighlighted: TCheckBox;
    lblItemId: TLabel;
    edtItemId: TEdit;
    edtDescription: TMemo;
    ImageURL: TImage;
    Button1: TButton;
    Memo1: TMemo;
    edtPrice: TNumberBox;
    Str: TRectangle;
    Rectangle7: TRectangle;
    ShadowEffect1: TShadowEffect;
    Image3: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RoundRect1MouseLeave(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rctMenuDiningClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NewDirectoryPath :String;
    MenuButtons : TObjectList<TRoundRect>;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses FMX.Helpers, System.IOUtils;

procedure TForm1.Button1Click(Sender: TObject);
begin

  var  ItemJSON := TJSONObject.Create;
  ItemJSON.AddPair('name', edtName.Text);
  ItemJSON.AddPair('description', edtDescription.Text);
  ItemJSON.AddPair('price', TJSONNumber.Create(StrToFloat(edtPrice.Text)));
  ItemJSON.AddPair('category', cmbCategory.Items[cmbCategory.ItemIndex]);
  ItemJSON.AddPair('imageURL', ImageURL.hint);
  ItemJSON.AddPair('availability', TJSONBool.Create(chkAvailability.IsChecked));
  ItemJSON.AddPair('highlighted', TJSONBool.Create(chkHighlighted.IsChecked));
  //ItemJSON.AddPair('deletedAt', edtDeletedAt.Text); // Substitua pela data desejada

  if edtItemId.Text <> '' then
     ItemJSON.AddPair('itemId', TJSONNumber.Create(StrToInt(edtItemId.Text)));

  Memo1.Lines.Text := ItemJSON.Format;

  ItemJSON.Free;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   MenuButtons := TObjectList<TRoundRect>.Create;
   MenuButtons.Add(rctTop);
   MenuButtons.Add(RoundRect1);
   MenuButtons.Add(RoundRect2);
   MenuButtons.Add(rctMenuDining);
   MenuButtons.Add(RoundRect3);
   MenuButtons.Add(RoundRect4);
   MenuButtons.Add(RoundRect5);
   MenuButtons.Add(RoundRect6);
   MenuButtons.Add(RoundRect9);
   MenuButtons.Add(RoundRect8);
   MenuButtons.Add(rctBotton);

   TabControl1.GotoVisibleTab(1);

   NewDirectoryPath := TPath.Combine(GetCurrentDir, 'Img');
   ForceDirectories(NewDirectoryPath);

end;

procedure TForm1.rctMenuDiningClick(Sender: TObject);
begin
   if TRectangle(Sender).Tag = 0 then
      TabControl1.GotoVisibleTab(TRectangle(Sender).Tag)
   else
      TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.RoundRect1MouseLeave(Sender: TObject);
var
  SelectedRect: TRoundRect;
  i, j: Integer;
begin
   if Sender is TRoundRect then begin
      SelectedRect := Sender as TRoundRect;
      // Localiza o índice do TRoundRect clicado na lista Botoes
      j := MenuButtons.IndexOf(SelectedRect);

      if (j > 0) and (j < MenuButtons.Count - 1) then begin
           // Define as propriedades do TRoundRect clicado
         SelectedRect.Fill.Color := TAlphaColors.White;
         SelectedRect.Corners := [TCorner.TopLeft, TCorner.BottomRight, TCorner.BottomLeft];

         // Restaura a cor original e os cantos dos outros TRoundRect na lista
         for i := 0 to MenuButtons.Count - 1 do begin
            if MenuButtons[i] <> SelectedRect then  begin
               MenuButtons[i].Fill.Color := TAlphaColors.Steelblue;
               MenuButtons[i].Corners := [];
               // Percorre os controles dentro do TRoundRect e define a cor do TText ou TSkLabel
               for var Control in MenuButtons[i].Controls do begin
                  if Control is TSkSvg then
                     (Control as TSkSvg).Svg.OverrideColor := TAlphaColors.White
                  else if Control is TSkLabel then
                    (Control as TSkLabel).TextSettings.FontColor := TAlphaColors.White
                  else if Control is TImage then
                    (Control as TImage).Bitmap.ReplaceOpaqueColor(TAlphaColors.White);

               end;
            end else begin
               // Percorre os controles dentro do TRoundRect clicado e define a cor do TText ou TSkLabel
               for var Control in SelectedRect.Controls do begin
                 if Control is TSkSvg then
                    (Control as TSkSvg).Svg.OverrideColor := TAlphaColors.Steelblue
                 else if Control is TSkLabel then
                   (Control as TSkLabel).TextSettings.FontColor := TAlphaColors.Steelblue
                 else if Control is TImage then
                    (Control as TImage).Bitmap.ReplaceOpaqueColor(TAlphaColors.Steelblue);

               end;
            end;
         end;

         // Define as propriedades dos TRoundRect acima e abaixo
         if j > 0 then
            MenuButtons[j - 1].Corners := [TCorner.BottomRight];

         if (j < MenuButtons.Count - 1) then
            MenuButtons[j + 1].Corners := [TCorner.TopRight];
      end;
   end;
end;

end.
