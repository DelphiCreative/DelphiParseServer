unit uItemData;

interface

uses
  System.JSON, System.SysUtils, System.Generics.Collections, System.Generics.Defaults;

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
function SortItemsByField(var AItems: TArray<TItem>; const AFieldName: string): TArray<TItem>;
function FilterItemsByField(const AItems: TArray<TItem>; const AFieldName: string; const AFilterValue: string): TArray<TItem>;

implementation
function ParseItems(const AJsonStr: string): TArray<TItem>;
var
  jsonValue: TJSONValue;
  jsonArray: TJSONArray;
  jsonItem: TJSONValue;
  item: TItem;
  i: Integer;
begin
  Result := nil;

  try
    // Obter o valor JSON raiz (um array neste caso)
    jsonValue := TJSONObject.ParseJSONValue(AJsonStr);

    if Assigned(jsonValue) and (jsonValue is TJSONArray) then
    begin
      jsonArray := TJSONArray(jsonValue);

      // Inicializar o array de itens com o tamanho do array JSON
      SetLength(Result, jsonArray.Count);

      // Percorrer o array JSON e extrair os dados diretamente
      for i := 0 to jsonArray.Count - 1 do
      begin
        jsonItem := jsonArray.Items[i];

        if Assigned(jsonItem) and (jsonItem is TJSONObject) then
        begin
          // Preencher o item diretamente a partir do objeto JSON
          item.itemId := jsonItem.GetValue<Integer>('itemId');
          item.name := jsonItem.GetValue<string>('name');
          item.description := jsonItem.GetValue<string>('description');
          item.price := jsonItem.GetValue<string>('price');
          item.availability := jsonItem.GetValue<Boolean>('availability');
          item.highlighted := jsonItem.GetValue<Boolean>('highlighted');
          item.category := jsonItem.GetValue<string>('category');
          item.imageUrl := jsonItem.GetValue<string>('imageUrl');

          // Atribuir o item ao array de resultado
          Result[i] := item;
        end;
      end;
    end;
  finally
    // Liberar o valor JSON raiz (não é necessário liberar os itens individuais)
    jsonValue.Free;
  end;
end;

function SortItemsByField(var AItems: TArray<TItem>; const AFieldName: string): TArray<TItem>;
var
  Comparer: IComparer<TItem>;
begin
  if AFieldName = 'name' then
    Comparer := TComparer<TItem>.Construct(
      function(const Left, Right: TItem): Integer
      begin
        Result := CompareText(Left.name, Right.name);
      end
    )
  else if AFieldName = 'category' then
    Comparer := TComparer<TItem>.Construct(
      function(const Left, Right: TItem): Integer
      begin
        Result := CompareText(Left.category, Right.category);
      end
    )
  else if AFieldName = 'price' then
    Comparer := TComparer<TItem>.Construct(
      function(const Left, Right: TItem): Integer
      begin
        // Implemente a lógica de comparação para o campo 'price' (convertendo para número, etc.)
        // Exemplo:
        // Result := CompareValue(StrToFloat(Left.price), StrToFloat(Right.price));
        // ou
        // Result := CompareText(Left.price, Right.price);
      end
    );
    // Adicione outras condições para outros campos, se necessário...

  if Assigned(Comparer) then
    TArray.Sort<TItem>(AItems, Comparer);

  Result := AItems;
end;

function FilterItemsByField(const AItems: TArray<TItem>; const AFieldName: string; const AFilterValue: string): TArray<TItem>;
var
  Item: TItem;
begin
  Result := [];
  for Item in AItems do
  begin
    if AFieldName = 'category' then
    begin
      if SameText(Item.category, AFilterValue) then
        Result := Result + [Item];
    end
    else if AFieldName = 'availability' then
    begin
      if (AFilterValue = 'true') and Item.availability then
        Result := Result + [Item]
      else if (AFilterValue = 'false') and not Item.availability then
        Result := Result + [Item];
    end;
    // Adicione outras condições para outros campos, se necessário...
  end;
end;

end.

