program DesktopMenu;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form1},
  FMX.Functions in '..\Units\FMX.Functions.pas',
  FMX.Helpers in '..\Units\FMX.Helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
