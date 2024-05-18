unit uFraItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Effects, uItemData;

type
  TfraItem = class(TFrame)
    rctBackground: TRectangle;
    ShadowEffect1: TShadowEffect;
    GridPanelLayout1: TGridPanelLayout;
    LayTop: TLayout;
    rctImageURL: TRectangle;
    ShadowEffect2: TShadowEffect;
    Layout4: TLayout;
    txtCategory: TText;
    txtName: TText;
    layClient: TLayout;
    txtDescription: TText;
    layBotton: TLayout;
    txtPrice: TText;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AItem : TItem); overload;
  end;

implementation

{$R *.fmx}

uses FMX.Functions;

{ TfraItem }
constructor TfraItem.Create(AOwner: TComponent; AItem: TItem);
begin
   Inherited Create(AOwner);
   txtCategory.Text := AItem.category;
   txtName.Text := AItem.name;
   txtPrice.Text := AItem.price;
   txtDescription.Text := AItem.description;
   LoadImageToShape(rctImageURL,AItem.imageUrl, '','', true);

   Self.TagString := AItem.name + ' ' + AItem.description + ' ' + AItem.category;

end;

end.


