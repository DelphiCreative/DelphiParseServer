program CardapioMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  uMain in 'uMain.pas' {frmMain},
  uFraItem in 'uFraItem.pas' {fraItem: TFrame},
  uTestData in 'uTestData.pas',
  FMX.Functions in '..\Units\FMX.Functions.pas',
  uItemData in 'uItemData.pas',
  FMX.Helpers.Utils in 'FMX.Helpers.Utils.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
