unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, Skia, FMX.Skia, System.Generics.Collections, System.JSON,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.EditBox,
  FMX.NumberBox, FMX.Functions, FMX.Effects, FMX.Menus, FMX.ComboEdit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

function SendData(ApplicationID, RestApiKey: WideString; JsonData: TJSONObject;
  ClouFunction: WideString): WideString; stdcall; external 'ParseServe4App.dll';

type
  TForm1 = class(TForm)
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    RoundRect2: TRoundRect;
    SkSvg2: TSkSvg;
    SkLabel2: TSkLabel;
    rctMenuDashBoard: TRoundRect;
    imgMenuDashBoard: TSkSvg;
    lblMenuDashBoard: TSkLabel;
    RoundRect5: TRoundRect;
    SkSvg4: TSkSvg;
    SkLabel4: TSkLabel;
    RoundRect4: TRoundRect;
    SkSvg5: TSkSvg;
    SkLabel5: TSkLabel;
    RoundRect6: TRoundRect;
    SkSvg6: TSkSvg;
    SkLabel6: TSkLabel;
    rctMenuHome: TRoundRect;
    imgMenuHome: TSkSvg;
    lblMenuHome: TSkLabel;
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
    Memo1: TMemo;
    edtPrice: TNumberBox;
    Str: TRectangle;
    Rectangle7: TRectangle;
    ShadowEffect1: TShadowEffect;
    Image3: TImage;
    Label1: TLabel;
    Rectangle3: TRectangle;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure RoundRect1MouseLeave(Sender: TObject);
    procedure rctMenuDiningClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PathImg :String;
    PathData :String;
    MenuButtons : TObjectList<TRoundRect>;
    procedure ItemSaveASync(AJsonResponse: string);
    procedure LoadMenu;
    procedure Database;
    procedure SaveItemToLocalDatabase(AJson :TJSONObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses FMX.Helpers, System.IOUtils, Parse.Server, AppConfig, SQLiteConnection;

var
  Parse : TParseServer;
  SQLiteConnection : TSQLiteConnection;

procedure TForm1.Database;
begin

  SQLiteConnection := TSQLiteConnection.Create;

  try

    SQLiteConnection.AddScript(
        'CREATE TABLE Item (' +
        '    id INTEGER PRIMARY KEY AUTOINCREMENT,' +
        '    json_data TEXT' +
        ');'
      );

    SQLiteConnection.DatabaseName := TPath.Combine(PathData, 'parse.db');
    SQLiteConnection.Open;

  finally
    SQLiteConnection.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   LoadMenu;

   TabControl1.GotoVisibleTab(1);

   PathImg := TPath.Combine(GetCurrentDir, 'Img');
   ForceDirectories(PathImg);

   PathData := TPath.Combine(GetCurrentDir, 'Data');
   ForceDirectories(PathData);

   Database;

   ImageURL.EnableImagePopup;

   Parse := TParseServer.Create;
   Parse.ApplicationID := ApplicationId;
   Parse.RestApiKey := RestApiKey;

end;

procedure TForm1.ItemSaveASync(AJsonResponse: string);
begin

end;

procedure TForm1.Label1Click(Sender: TObject);
begin
  var getItemsList := 'getItemsList';
  Memo1.Lines.Add(
  Parse.EndPoint(getItemsList)
    .AddPair('category', 'PIZZ%')
    .Send);

end;

procedure TForm1.LoadMenu;
begin
   MenuButtons := TObjectList<TRoundRect>.Create;
   MenuButtons.Add(rctTop);
   MenuButtons.Add(rctMenuHome);
   MenuButtons.Add(RoundRect2);
   MenuButtons.Add(rctMenuDining);
   MenuButtons.Add(rctMenuDashBoard);
   MenuButtons.Add(RoundRect4);
   MenuButtons.Add(RoundRect5);
   MenuButtons.Add(RoundRect6);
   MenuButtons.Add(RoundRect9);
   MenuButtons.Add(RoundRect8);
   MenuButtons.Add(rctBotton);
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

procedure TForm1.SaveItemToLocalDatabase(AJson: TJSONObject);
var
  FDQuery: TFDQuery;
  ItemJSON: TJSONObject;
  JSONString: string;
  ItemID: string;
begin
  JSONString := AJson.ToString;
  ItemID := JSONString.FindJsonValue('itemId');

  FDQuery := TFDQuery.Create(nil);
  FDQuery.Connection := SQLiteConnection.Connection;

  try
    // Verifique se o registro com o ID já existe na tabela
    FDQuery.SQL.Text := 'SELECT COUNT(1) FROM Item WHERE id = :item_id';
    FDQuery.ParamByName('item_id').AsString := ItemID;
    FDQuery.Open;

    if FDQuery.Fields[0].AsInteger > 0 then
    begin
      // Se o registro existir, faça a atualização
      FDQuery.SQL.Text := 'UPDATE Item SET json_data = :json_data WHERE id = :item_id';
    end
    else
    begin
      // Se o registro não existir, faça a inserção
      FDQuery.SQL.Text := 'INSERT INTO Item (id, json_data) VALUES (:item_id, :json_data)';
      FDQuery.ParamByName('item_id').AsString := ItemID;
    end;

    // Configure os parâmetros comuns para inserção/atualização
    FDQuery.ParamByName('json_data').AsString := JSONString;
    FDQuery.ExecSQL;

  finally
    FDQuery.Free;
  end;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  return, imgResize :string;
begin

  var createOrUpdateItem := 'createOrUpdateItem';

  imgResize := ResizeImage(ImageURL.hint,100,100, PathImg);

  //imgResize := ResizeImageProportional(ImageURL.hint,50, PathImg);

  var ItemJSON := TJSONObject.Create;

  ItemJSON.AddPair('name', edtName.Text)
    .AddPair('description', edtDescription.Text)
    .AddPair('price', TJSONNumber.Create(StrToFloat(edtPrice.Text)))
    .AddPair('category', cmbCategory.Items[cmbCategory.ItemIndex])
    .AddPair('imageURL', EncodeFileToJSON(imgResize))
    .AddPair('availability', TJSONBool.Create(chkAvailability.IsChecked))
    .AddPair('highlighted', TJSONBool.Create(chkHighlighted.IsChecked));

  if edtItemId.Text <> '' then
     ItemJSON.AddPair('itemId', TJSONNumber.Create(StrToInt(edtItemId.Text)));

   Memo1.Lines.Text := ItemJSON.Format;

  {Método para o envio de dados com ParseServe4App.dll}
  //return := SendData(ApplicationId,RestApiKey,ItemJSON,createOrUpdateItem);

  {Método 1 para o envio de dados com Parse.Server.pas}
  return := Parse.SendData(ItemJSON,createOrUpdateItem);

  {Método 2 para o envio de dados encadeados com Parse.Server.pas}

  {Parse.EndPoint(createOrUpdateItem)
    .AddPair('name', edtName.Text)
    .AddPair('description', edtDescription.Text)
    .AddPair('price', StrToFloat(edtPrice.Text))
    .AddPair('category', cmbCategory.Items[cmbCategory.ItemIndex])
    .AddPair('imageURL', ImageURL.hint)
    .AddPair('availability',chkAvailability.IsChecked)
    .AddPair('highlighted', chkHighlighted.IsChecked);

  if edtItemId.Text <> '' then
     Parse.AddPair('itemId',StrToInt(edtItemId.Text));
  return := Parse.Send();}


  Memo1.Lines.Add(return);

  if edtItemId.Text = '' then begin
     edtItemId.Text := return.FindJsonValue('itemId');
     ItemJSON.AddPair('itemId', TJSONNumber.Create(StrToInt(edtItemId.Text)));
  end;

  SaveItemToLocalDatabase(ItemJSON);

  ItemJSON.Free;

end;

end.
