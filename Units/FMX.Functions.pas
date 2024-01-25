unit FMX.Functions;

interface

uses
  FMX.Controls,
  FMX.Dialogs,
  FMX.Graphics,
  FMX.Objects,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.NetEncoding,
  System.Threading,
  System.Types;

procedure LoadImageToImage(AImageControl: TImage; AURL, ACustomFileName, ACustomPath: string;
  AUseCache: Boolean);

procedure LoadImageToShape(AShape: TShape; AURL, ACustomFileName, ACustomPath: string;
  AUseCache: Boolean);

function RemoveKeyFromFileName(const FileName: string): string;

function ResizeImage(const OriginalImage: TBitmap; const NewWidth, NewHeight: Integer): TBitmap; overload;

function ResizeImage(const ImagePath: string; const NewWidth, NewHeight: Integer;
  const DestinationPath: string = ''): string; overload;

function ResizeImageProportional(const ImagePath: string; const MaxSize: Integer;
  const DestinationPath: string = ''): string;

function EncodeFileToJSON(const FilePath: string): TJSONObject;

implementation

uses
  System.IOUtils, System.Generics.Collections, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent,System.Generics.Defaults;

function EncodeFileToJSON(const FilePath: string): TJSONObject;
var
  FileStream: TFileStream;
  ByteArray: TArray<Byte>;
  Base64String: string;
begin
  // Verifica se FilePath é uma string vazia
  if FilePath = '' then
  begin
    Result := TJSONObject.Create;
    Result.AddPair('name', '');
    Exit; // Sai da função imediatamente
  end;

  if not FileExists(FilePath) then
    raise Exception.CreateFmt('Arquivo "%s" não encontrado.', [FilePath]);

  FileStream := TFileStream.Create(FilePath, fmOpenRead);
  try
    SetLength(ByteArray, FileStream.Size);
    FileStream.Read(ByteArray[0], FileStream.Size);
    Base64String := TNetEncoding.Base64.EncodeBytesToString(ByteArray);

    Result := TJSONObject.Create;
    Result.AddPair('name', ExtractFileName(FilePath));
    Result.AddPair('base64', Base64String);
  finally
    FileStream.Free;
  end;
end;


procedure LoadImageToImage(AImageControl: TImage; AURL, ACustomFileName, ACustomPath: string;
  AUseCache: Boolean);
var
  LocalFilePath: string;
  ValidImageExtensions: TArray<string>;
  Ext: string;
  IsValidExtension: Boolean;
  ValidExt: string;
begin
  if AImageControl = nil then
    Exit;

  ValidImageExtensions := ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.ico'];

  if ACustomFileName = '' then
    ACustomFileName := RemoveKeyFromFileName(TPath.GetFileName(AURL));

  LocalFilePath := TPath.Combine(ACustomPath, ACustomFileName);
  Ext := ExtractFileExt(ACustomFileName);

  IsValidExtension := False;
  for ValidExt in ValidImageExtensions do
  begin
    if SameText(Ext, ValidExt) then
    begin
      IsValidExtension := True;
      Break;
    end;
  end;

  if (SameText(Ext, '') or IsValidExtension) then
  begin
    if AUseCache and TFile.Exists(LocalFilePath) then
    begin
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          AImageControl.Bitmap.LoadFromFile(LocalFilePath);
        end);
    end
    else
    begin
      TThread.CreateAnonymousThread(
        procedure
        var
          MyFileStream: TFileStream;
          NetHTTPClient: TNetHTTPClient;
        begin
          MyFileStream := TFileStream.Create(LocalFilePath, fmCreate);
          try
            NetHTTPClient := TNetHTTPClient.Create(nil);
            try
              NetHTTPClient.Get(AURL, MyFileStream);
            finally
              NetHTTPClient.Free;
            end;
          finally
            MyFileStream.Free;
          end;

          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              try
                AImageControl.Bitmap.LoadFromFile(LocalFilePath);
              except
                AImageControl.Bitmap := nil;
              end;
            end);
        end).Start;
    end;
  end
  else
  begin
    ShowMessage('Extensão de arquivo inválida.');
  end;
end;

procedure LoadImageToShape(AShape: TShape; AURL, ACustomFileName, ACustomPath: string;
  AUseCache: Boolean);
var
  LocalFilePath: string;
  ValidImageExtensions: TArray<string>;
  Ext: string;
  IsValidExtension: Boolean;
  ValidExt: string;
  Bitmap: TBitmap;
begin
  if AShape = nil then
    Exit;

  ValidImageExtensions := ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.ico'];

  if ACustomFileName = '' then
    ACustomFileName := RemoveKeyFromFileName(TPath.GetFileName(AURL));

  LocalFilePath := TPath.Combine(ACustomPath, ACustomFileName);
  Ext := ExtractFileExt(ACustomFileName);

  IsValidExtension := False;
  for ValidExt in ValidImageExtensions do
  begin
    if SameText(Ext, ValidExt) then
    begin
      IsValidExtension := True;
      Break;
    end;
  end;

  if (SameText(Ext, '') or IsValidExtension) then
  begin
    Bitmap := AShape.Fill.Bitmap.Bitmap;

    if AUseCache and TFile.Exists(LocalFilePath) then
    begin
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          Bitmap.LoadFromFile(LocalFilePath);
        end);
    end
    else
    begin
      TThread.CreateAnonymousThread(
        procedure
        var
          MyFileStream: TFileStream;
          NetHTTPClient: TNetHTTPClient;
        begin
          MyFileStream := TFileStream.Create(LocalFilePath, fmCreate);
          try
            NetHTTPClient := TNetHTTPClient.Create(nil);
            try
              NetHTTPClient.Get(AURL, MyFileStream);
            finally
              NetHTTPClient.Free;
            end;
          finally
            MyFileStream.Free;
          end;

          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              try
                Bitmap.LoadFromFile(LocalFilePath);
              except
                Bitmap := nil;
              end;
            end);
        end).Start;
    end;
  end
  else
  begin
    ShowMessage('Extensão de arquivo inválida.');
  end;
end;


function RemoveKeyFromFileName(const FileName: string): string;
var
  KeyLength: Integer;
begin
  KeyLength := 32;

  if Length(FileName) > KeyLength then
    Result := Copy(FileName, KeyLength + 2, MaxInt)
  else
    Result := FileName;
end;

function ResizeImage(const OriginalImage: TBitmap; const NewWidth, NewHeight: Integer): TBitmap; overload;
var
  SrcRect, DestRect: TRectF;
begin
  Result := TBitmap.Create;
  try
    Result.SetSize(NewWidth, NewHeight);

    SrcRect := RectF(0, 0, OriginalImage.Width, OriginalImage.Height);
    DestRect := RectF(0, 0, NewWidth, NewHeight);

    Result.Canvas.BeginScene;
    Result.Canvas.DrawBitmap(OriginalImage, SrcRect, DestRect, 1);
    Result.Canvas.EndScene;
  except
    on E: Exception do
    begin
      Result.Free;
      Result := nil;
    end;
  end;

end;

function ResizeImage(const ImagePath: string; const NewWidth, NewHeight: Integer;
  const DestinationPath: string = ''): string; overload;
var
  OriginalImage, ResizedImage: TBitmap;
  FileName, DestinationFilePath: string;
begin

  if ImagePath = '' then
    Exit;

  if not FileExists(ImagePath) then
    raise Exception.CreateFmt('Arquivo "%s" não encontrado.', [ImagePath]);

  OriginalImage := TBitmap.Create;
  ResizedImage := TBitmap.Create;

  try
    OriginalImage.LoadFromFile(ImagePath);
    ResizedImage := ResizeImage(OriginalImage, NewWidth, NewHeight);

    FileName := ExtractFileName(ImagePath);

    if DestinationPath <> '' then
      DestinationFilePath := TPath.Combine(DestinationPath, FileName)
    else
      DestinationFilePath := TPath.Combine(TPath.GetTempPath, FileName);

    ResizedImage.SaveToFile(DestinationFilePath);
    Result := DestinationFilePath;
  finally
    OriginalImage.Free;
    ResizedImage.Free;
  end;
end;

function ResizeImageProportional(const ImagePath: string; const MaxSize: Integer;
  const DestinationPath: string = ''): string;
var
  OriginalImage, ResizedImage: TBitmap;
  FileName, DestinationFilePath: string;
  ScaleFactor: Single;
  NewWidth, NewHeight: Integer;
begin

  if ImagePath = '' then
    Exit;

  if not FileExists(ImagePath) then
    raise Exception.CreateFmt('Arquivo "%s" não encontrado.', [ImagePath]);

  OriginalImage := TBitmap.Create;
  ResizedImage := TBitmap.Create;

  try
    OriginalImage.LoadFromFile(ImagePath);

    if OriginalImage.Width > OriginalImage.Height then
      ScaleFactor := MaxSize / OriginalImage.Width
    else
      ScaleFactor := MaxSize / OriginalImage.Height;

    NewWidth := Round(OriginalImage.Width * ScaleFactor);
    NewHeight := Round(OriginalImage.Height * ScaleFactor);

    ResizedImage := ResizeImage(OriginalImage, NewWidth, NewHeight);

    FileName := ExtractFileName(ImagePath);

    if DestinationPath <> '' then
      DestinationFilePath := TPath.Combine(DestinationPath, FileName)
    else
      DestinationFilePath := TPath.Combine(TPath.GetTempPath, FileName);

    ResizedImage.SaveToFile(DestinationFilePath);
    Result := DestinationFilePath;
  finally
    OriginalImage.Free;
    ResizedImage.Free;
  end;
end;

end.
