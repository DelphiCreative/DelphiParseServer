unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Effects, FMX.Objects, FMX.TabControl, FMX.Gestures, System.Generics.Collections;

type
  TfrmMain = class(TForm)
    VertScrollBox1: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadItems;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uFraItem, uItemData, uTestData;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   LoadItems;
end;

procedure TfrmMain.LoadItems;
var
   FraItem : TfraItem;
   I: Integer;
   Items :TArray<TItem>;
   Item : TItem;
begin

   Items := ParseItems(JsonItem);

   for item in Items do
   begin
      FraItem := TfraItem.Create(Self, Item);
      FraItem.Name := 'fra'+ IntToStr(Item.itemId);
      VertScrollBox1.AddObject(FraItem);
   end;
end;

end.
