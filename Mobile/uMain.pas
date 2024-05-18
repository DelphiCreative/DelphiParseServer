unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Effects, FMX.Objects, FMX.TabControl, FMX.Gestures, System.Generics.Collections,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation;

type
  TfrmMain = class(TForm)
    vsbItems: TVertScrollBox;
    rcTop: TRectangle;
    ShadowEffect1: TShadowEffect;
    rctSearchItem: TRectangle;
    edtSearchItem: TEdit;
    SearchEditButton1: TSearchEditButton;
    SpeedButton1: TSpeedButton;
    TabControl1: TTabControl;
    procedure FormCreate(Sender: TObject);
    procedure edtSearchItemChangeTracking(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     ListFrame : TObjectList<TFrame>;
     procedure LoadItems;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uFraItem, uItemData, uTestData, FMX.Helpers.Utils;

procedure TfrmMain.edtSearchItemChangeTracking(Sender: TObject);
begin
   ListFrame.Filter(TEdit(Sender).text);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   LoadItems;
end;

procedure TfrmMain.LoadItems;
var
   FraItem : TfraItem;
   Items: TArray<TItem>;
   Item : TItem;
begin

   Items := ParseItems(JsonItem);

   ListFrame := TObjectList<TFrame>.Create;

   vsbItems.BeginUpdate;
   for item in Items do
   begin
      FraItem := TfraItem.Create(Self, Item);
      FraItem.Name := 'fra'+ IntToStr(Item.itemId);
      ListFrame.Add(FraItem);
      vsbItems.AddObject(FraItem);

      if Item.highlighted then begin
         var TabItem := TTabItem.Create(Self);
         TabItem.Parent := TabControl1;
         FraItem := TfraItem.Create(Self, Item);
         FraItem.Name := 'fra_slide'+ IntToStr(Item.itemId);
         TabItem.AddObject(FraItem);
      end;

   end;
   vsbItems.EndUpdate;

   TabControl1.Slide;

end;


end.
