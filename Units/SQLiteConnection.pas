unit SQLiteConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.IOUtils, System.Variants,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;


type
  TSQLiteConnection = class
  private
    class var FConnection: TFDConnection;
    class var FScript: TFDScript;
    class var FDatabaseName: String;
    class function GetConnection: TFDConnection; static;
    class function GetVersion: Integer;
    class procedure ConfigureConnection; static;
    class procedure ExecuteScripts; static;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Open;
    procedure AddScript(const SQL: string);

    class property Connection: TFDConnection read GetConnection;
    class property DatabaseName: string read FDatabaseName write FDatabaseName;
  end;

implementation

{ TSQLiteFireDACConnection }

class procedure TSQLiteConnection.ConfigureConnection;
var
  AppName: string;
begin
  AppName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');

  FConnection.DriverName := 'SQLite';
  FConnection.Params.Database := TPath.Combine(TPath.GetDocumentsPath, AppName + '.db');

  if FDatabaseName <> '' then
    FConnection.Params.Database := TPath.Combine(TPath.GetDocumentsPath, FDatabaseName);
end;

class constructor TSQLiteConnection.Create;
begin
  FConnection := TFDConnection.Create(nil);
  FScript := TFDScript.Create(nil);

end;

class destructor TSQLiteConnection.Destroy;
begin
  FScript.Free;
  FConnection.Free;
end;

class procedure TSQLiteConnection.ExecuteScripts;
var
  currentVersion, I: Integer;
begin
  currentVersion := GetVersion;

  for I := currentVersion to FScript.SQLScripts.Count - 1 do
  begin
    try
      FConnection.ExecSQL(FScript.SQLScripts.Items[I].SQL.Text);
    finally
      FConnection.ExecSQL('UPDATE Version SET DBVersion =' + IntToStr(I + 1));
    end;
  end;
end;

class function TSQLiteConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;



class function TSQLiteConnection.GetVersion: Integer;
var
  version: Variant;
begin
  FConnection.ExecSQL('CREATE TABLE IF NOT EXISTS Version (DBVersion INTEGER);');

  try
    version := FConnection.ExecSQLScalar('SELECT DBVersion FROM Version');
    if not VarIsNull(version) then
    begin
      if version = 0 then
      begin
        FConnection.ExecSQL('INSERT INTO Version (DBVersion) VALUES (0)');
        Result := 0;
      end
      else
        Result := version;
    end
    else
      Result := -1;
  except
    on E: Exception do
    begin
      raise Exception.Create('GetVersion ' + E.Message);
    end;
  end;
end;

procedure TSQLiteConnection.AddScript(const SQL: string);
begin
  FScript.SQLScripts.Add.SQL.Add(SQL);
end;

class procedure TSQLiteConnection.Open;
begin
  ConfigureConnection;
  FConnection.Connected := True;
  ExecuteScripts;
end;

end.

