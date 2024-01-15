# Guia do Projeto

## Capítulo 1: Estrutura do Banco de Dados

### 1. Criar Classes no Back4App
   - [1.1 Criar a Classe `Category`](#11-criar-a-classe-category)
   - [1.2 Criar a Classe `Item`](#12-criar-a-classe-item)
   - [1.3 Criar a Classe `IDAutoGen`](#13-criar-a-classe-idautogen)
 
## 1.1 Criar a Classe `Category`
   - Vá para a seção "Database".
   - Clique em "Create a Class" e nomeie a classe como `Category`.
   - Adicione os seguintes campos:
     - `name` (String) - Nome da categoria
     - Outros campos relacionados à categoria, se necessário.
   - Salve as configurações da classe

## 1.2 Criar a Classe `Item`
   - Clique em "Create a Class" novamente e nomeie a classe como `Item`.
   - Adicione os seguintes campos:
     - `name` (String) - Nome do item
     - `description` (String) - Descrição do item
     - `price` (Number) - Preço
     - `category` (Pointer to `Category`) - Ponteiro para a classe `Category`
     - `imageURL` (File) - Arquivo de imagem do item
     - `availability` (Boolean) - Disponibilidade do item
     - `highlighted` (Boolean) - Destaque do item
     - `deletedAt` (Date) - Data de exclusão do item (campo opcional)
     - `itemId` (Number) - Identificador único do item
   - Salve as configurações da classe.

## 1.3 Criar a Classe `IDAutoGen`
   - Clique em "Create a Class" novamente e nomeie a classe como `IDAutoGen`.
   - Adicione os seguintes campos:
     - `nameClass` (String) - Nome da classe para a qual os IDs serão gerados
     - `nextId` (Number) - Próximo ID a ser atribuído
   - Salve as configurações da classe.

## Capítulo 2: Descrição das Funções do main.js

1. **`Parse.Cloud.define("hello", (request) => {...})`**: Retorna o parâmetro 'nome' enviado na requisição.
2. **`Parse.Cloud.define("createOrUpdateItem", async (req) => {...})`**: Gerencia a criação ou atualização de um item, verificando se um item já existe com base no ID fornecido e atualizando ou criando um novo item.
3. **`Parse.Cloud.define("createOrUpdateItems", async (req) => {...})`**: Permite a criação ou atualização de vários itens simultaneamente.
4. **`async function getOrCreateItemId(itemId) {...}`**: Obtém ou cria um novo ID para um item, gerando um novo se não for fornecido.
5. **`async function getNextId(className) {...}`**: Obtém o próximo ID disponível para uma classe específica, incrementando o valor de ID na classe `IDAutoGen`.
6. **`async function findOrCreateObject(className, fieldName, fieldValue) {...}`**: Busca ou cria um novo objeto em uma classe específica com base em um campo e valor fornecidos.
7. **`function maskSensitiveData(req) {...}`**: Usada para mascarar dados sensíveis em requisições, como IDs de aplicativos e chaves de API.

### Exemplo de JSON para `createOrUpdateItem`
```json
{
    "itemId": 123,
    "name": "Nome do Item",
    "description": "Descrição do Item",
    "price": 99.99,
    "category": "CategoriaID",
    "availability": true,
    "highlighted": false
}
```

### Exemplo de JSON para `createOrUpdateItems`
```json
[
    {
        "itemId": 123,
        "name": "Nome do Item 1",
        "description": "Descrição do Item 1",
        "price": 99.99,
        "category": "CategoriaID1",
        "availability": true,
        "highlighted": false
    },
    {
        "itemId": 124,
        "name": "Nome do Item 2",
        "description": "Descrição do Item 2",
        "price": 199.99,
        "category": "CategoriaID2",
        "availability": false,
        "highlighted": true
    }
]
```
