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
    constructor Create(AOwner: TComponent; Item : TItem); overload;
  end;

implementation

{$R *.fmx}

{ TfraItem }
constructor TfraItem.Create(AOwner: TComponent; Item: TItem);
begin
   Inherited Create(AOwner);
   txtCategory.Text := Item.category;
   txtName.Text := Item.name;
   txtPrice.Text := Item.price;
   txtDescription.Text := Item.description;
end;

end.


