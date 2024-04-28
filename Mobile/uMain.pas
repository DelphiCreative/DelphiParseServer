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

uses uFraItem;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   LoadItems;
end;

procedure TfrmMain.LoadItems;
var
   FraItem : TfraItem;
   I: Integer;
begin
   for I := 0 to 10 do
   begin
      FraItem := TfraItem.Create(Self);
      FraItem.Name := 'fra'+ IntToStr(I);
      VertScrollBox1.AddObject(FraItem);
   end;
end;

end.
