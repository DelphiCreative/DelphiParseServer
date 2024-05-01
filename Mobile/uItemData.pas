unit uItemData;

interface

uses
  System.JSON, System.SysUtils, System.Generics.Collections;

type
  TItem = record
    itemId: Integer;
    name: string;
    description: string;
    price: string;
    availability: Boolean;
    highlighted: Boolean;
    category: string;
    imageUrl: string;
  end;

function ParseItems(const AJsonStr: string): TArray<TItem>;

implementation

function ParseItems(const AJsonStr: string): TArray<TItem>;
var
  jsonObject: TJSONObject;
  itemsArray: TJSONArray;
  i: Integer;
begin
  Result := nil;

  try
    jsonObject := TJSONObject.ParseJSONValue(AJsonStr) as TJSONObject;

    if Assigned(jsonObject) then
    begin
      itemsArray := jsonObject.Values['result'] as TJSONArray;

      if Assigned(itemsArray) then
      begin
        SetLength(Result, itemsArray.Count);

        for i := 0 to itemsArray.Count - 1 do
        begin
          jsonObject := itemsArray.Items[i] as TJSONObject;
          if Assigned(jsonObject) then
          begin
            Result[i].itemId := jsonObject.GetValue<Integer>('itemId');
            Result[i].name := jsonObject.GetValue<string>('name');
            Result[i].description := jsonObject.GetValue<string>('description');
            Result[i].price := jsonObject.GetValue<string>('price');
            Result[i].availability := jsonObject.GetValue<Boolean>('availability');
            Result[i].highlighted := jsonObject.GetValue<Boolean>('highlighted');
            Result[i].category := jsonObject.GetValue<string>('category');
            Result[i].imageUrl := jsonObject.GetValue<string>('imageUrl');
          end;
        end;
      end;
    end;
  except
    // Trate exceções, se necessário
  end;
end;

end.

