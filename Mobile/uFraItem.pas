unit uFraItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Effects;

type
  TfraItem = class(TFrame)
    rctBackground: TRectangle;
    ShadowEffect1: TShadowEffect;
    GridPanelLayout1: TGridPanelLayout;
    LayTop: TLayout;
    Rectangle3: TRectangle;
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
  end;

implementation

{$R *.fmx}

end.
