const Item = Parse.Object.extend("Item")
const IDAutoGen = Parse.Object.extend("IDAutoGen")

Parse.Cloud.define("hello", (request) => { 	
	return request.params.nome
});

Parse.Cloud.define("createOrUpdateItem", async (req) => {
    const itemId = req.params.itemId;
    const price = req.params.price;
    const description = req.params.description;
    const name = req.params.name;
    const categoryName = req.params.category;
    const availability = req.params.availability;
    const highlighted = req.params.highlighted;
    const imageURL = req.params.imageURL;    
    
    if (!name || name === "") {
        return { error: "Nome do item é obrigatório" };
    }

    if (price === undefined || price === null || price === "") {
        return { error: "Preço é obrigatório" };
    }

    const { item, msg } = await getOrCreateItemId(itemId);

    item.set("price", parseFloat(price));
    item.set("name", name);
    item.set("description", description);
    item.set("availability", availability);
    item.set("highlighted", highlighted);
    item.set("deletedAt", null);

    if (categoryName) {        
        const category = await findOrCreateObject("Category", "name", categoryName);
        item.set("category", category);
    }

    if (imageURL && imageURL.name) {
        const parseFile = new Parse.File(imageURL.name, { base64: imageURL.base64 });
        item.set('imageURL', parseFile);
    } else {
        item.set('imageURL', null); 
    }

    await item.save(null, { useMasterKey: true });

    const responseJSON = {
        itemId: item.get("itemId"),
        success: msg
    };

    return responseJSON;
});


Parse.Cloud.define("createOrUpdateItems", async (req) => {
    const itemsData = req.params.items;

    if (!Array.isArray(itemsData) || itemsData.length === 0) {
        throw "A entrada deve ser um array de itens.";
    }

    const responseJSON = [];

    for (const itemData of itemsData) {
        const itemId = itemData.itemId;
        const price = itemData.price;
        const description = itemData.description;
        const name = itemData.name;
        const categoryName = itemData.category;
        const availability = itemData.availability;
        const highlighted = itemData.highlighted;

        if (!name || name === "") {
            responseJSON.push({ error: "Nome do item é obrigatório" });
            continue;
        }

        if (!price || price === "") {
            responseJSON.push({ error: "Preço é obrigatório" });
            continue;
        }

        const { item, msg } = await getOrCreateItemId(itemId);

        item.set("price", price === 0 ? 0 : parseFloat(price));
        item.set("name", name);
        item.set("description", description);
        item.set("availability", availability);
        item.set("highlighted", highlighted);
        item.set("deletedAt", null);

        if (categoryName) {        
            const category = await findOrCreateObject("Category", "name", categoryName);
            item.set("category", category);
        }

        await item.save(null, { useMasterKey: true });

        responseJSON.push({
            itemId: item.get("itemId"),
            success: msg
        });
    }

    return responseJSON;
});

Parse.Cloud.define("getItemsList", async (req) => {
    const query = new Parse.Query(Item);
    query.include("category");

    let page = req.params.page;
    let limite = req.params.limit;
    let orderBy = req.params.orderBy;
    const itemDescription = req.params.description;
    const categoryName = req.params.category;
    const itemId = req.params.itemId;

    if (page === undefined || isNaN(page) || page <= 0) {
        page = 1;
    }

    if (limite === undefined || isNaN(limite)) {
        limite = 10;
    }

    if (orderBy === undefined || orderBy === "") {
        orderBy = "itemId";
    }

    query.ascending(orderBy);
    query.limit(limite);
    query.skip((page - 1) * limite);
    
    if (itemId) {
        query.equalTo("itemId", itemId);
    }
   
    await applyTextFilter(query, "description", itemDescription);
    await applyPointerFilter(query, "Category", "name", categoryName);

    const item = await query.find({ useMasterKey: true });

    return item.map((item) => {
        // Obtém a URL da imagem antes de converter o item para JSON
        const imageUrl = item.get("imageURL") ? item.get("imageURL").url() : null;
    
        // Converte o item para JSON
        const itemData = item.toJSON();
    
        // Seleciona e formata apenas os campos necessários
        return {
            itemId: itemData.itemId, // ou objectId, se for o identificador único
            name: itemData.name,
            description: itemData.description,
            price: `R$ ${itemData.price.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
            availability: itemData.availability,
            highlighted: itemData.highlighted,
            category: itemData.category ? itemData.category.name : "",
            imageUrl: imageUrl // URL da imagem formatada
            // Inclua outros campos necessários aqui
        };
    });
    
    
});






// async Functions
async function getOrCreateItemId(itemId) {
    let item;
    let msg;

    if (!itemId || itemId === "") {
        const nextItemId = await getNextId("Item");
        item = new Item();
        item.set("itemId", nextItemId);
        msg = "Item incluído com sucesso";
    } else {
        const queryItem = new Parse.Query(Item);
        queryItem.equalTo("itemId", itemId);
        item = await queryItem.first({ useMasterKey: true });

        if (!item) {
            // Chama getNextId com o itemId fornecido para atualizar o próximo ID, se necessário
            await getNextId("Item", itemId);

            item = new Item();
            item.set("itemId", itemId);
            msg = "Item incluído com sucesso";
        } else {
            msg = "Item atualizado com sucesso";
        }
    }

    return { item, msg };
}

async function getNextId(className, receivedId) {
    const queryID = new Parse.Query(IDAutoGen);
    queryID.equalTo("nameClass", className);
    const idObject = await queryID.first({ useMasterKey: true });

    if (!idObject) {
        throw `ID não encontrado para a classe ${className}`;
    }

    let nextId = idObject.get("nextId");

    // Atualiza nextId se o receivedId for maior
    if (receivedId && receivedId > nextId) {
        idObject.set("nextId", receivedId + 1);
    } else {
        idObject.increment("nextId");
    }

    await idObject.save(null, { useMasterKey: true });

    return nextId;
}


async function findOrCreateObject(className, fieldName, fieldValue) {
    const ParseClass = Parse.Object.extend(className);
    const query = new Parse.Query(ParseClass);
    query.equalTo(fieldName, fieldValue.toUpperCase());
    let parseObject = await query.first({ useMasterKey: true });

    if (!parseObject) {
        parseObject = new ParseClass();
        parseObject.set(fieldName, fieldValue.toUpperCase());
        await parseObject.save(null, { useMasterKey: true });
    }

    return parseObject;
}


// Função para aplicar condição de pesquisa a campos de texto
async function applyTextFilter(query, field, value) {
    let fieldWithoutPercent = value;

    if (value) {
        if (value.endsWith("%") && value.startsWith("%")  ) {
            // Se o valor terminar com "%", use o operador "contains"
            fieldWithoutPercent = value.replace(/%/g, ""); // Remove o "%"
            query.contains(field, fieldWithoutPercent);
        } else if (value.endsWith("%")) {
            // Se o valor começar com "%", use o operador "startsWith"
            fieldWithoutPercent = value.replace(/%/g, ""); // Remove o "%"
            query.startsWith(field, fieldWithoutPercent);
        } else {
            query.equalTo(field, value);
        }
    }

    return fieldWithoutPercent;
}

async function applyPointerFilter(query, className, fieldName, filterValue) {
    if (!filterValue) return;

    let filterValueWithoutPercent = filterValue;
    const PointerClass = Parse.Object.extend(className);
    const pointerQuery = new Parse.Query(PointerClass);

    if (filterValue.startsWith("%") && filterValue.endsWith("%")) {
        // Se o valor do filtro terminar com "%", use o operador "contains"
        filterValueWithoutPercent = filterValue.replace(/%/g, "");
        pointerQuery.contains(fieldName, filterValueWithoutPercent);
    } else if (filterValue.endsWith("%")) {
        // Se o valor do filtro começar com "%", use o operador "startsWith"
        filterValueWithoutPercent = filterValue.replace(/%/g, "");
        pointerQuery.startsWith(fieldName, filterValueWithoutPercent);
    } else {
        // Correspondência exata
        pointerQuery.equalTo(fieldName, filterValue);
    }

    const results = await pointerQuery.find({ useMasterKey: true });
    if (results.length > 0) {
        query.containedIn(className.toLowerCase(), results);
    } else {
        // Se nenhum resultado for encontrado, aplique um filtro que sempre será falso
        query.equalTo("objectId", "nonexistent");
    }
}


function maskSensitiveData(req) {
    const sensitiveKeys = ['x-back4app-parseapp-appid', 'x-parse-application-id', 'x-parse-rest-api-key'];
    let safeReq = JSON.parse(JSON.stringify(req));

    // Mascara dados sensíveis nos headers
    Object.keys(safeReq.headers).forEach(key => {
        if (sensitiveKeys.includes(key)) {
            safeReq.headers[key] = '*****************';
        }
    });

    // Mascara o appId no log
    if (safeReq.log && safeReq.log.appId) {
        safeReq.log.appId = '*****************';
    }

    return safeReq;
}
