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
    const imagemURL = req.params.imagemURL;    

    if (!name || name === "") {
        throw "Nome do item é obrigatório";
    }

    if (!price || price === "") {
        throw "Preço é obrigatório";
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

    if (imagemURL && file.imagemURL) {
        const parseFile = new Parse.File(file.name, { base64: file.base64 });
        item.set('imagemURL', parseFile);
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

        await item.save(null, { useMasterKey: true });

        responseJSON.push({
            itemId: item.get("itemId"),
            success: msg
        });
    }

    return responseJSON;
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


function maskSensitiveData(req) {
    const sensitiveKeys = ['x-back4app-parseapp-appid', 'x-parse-application-id', 'x-parse-rest-api-key'];
    let safeReq = JSON.parse(JSON.stringify(req));
    
    Object.keys(safeReq.headers).forEach(key => {
        if (sensitiveKeys.includes(key)) {
            safeReq.headers[key] = '*****************';
        }
    });

    if (safeReq.log && safeReq.log.appId) {
        safeReq.log.appId = '*****************';
    }

    return safeReq;
}
