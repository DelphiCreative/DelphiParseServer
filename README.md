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
     - `objectId` (padrão do Back4App)
     - `name` (String) - Nome da categoria
     - Outros campos relacionados à categoria, se necessário.
   - Salve as configurações da classe

## 1.2 Criar a Classe `Item`
   - Clique em "Create a Class" novamente e nomeie a classe como `Item`.
   - Adicione os seguintes campos:
     - `objectId` (padrão do Back4App)
     - `name` (String) - Nome do item
     - `description` (String) - Descrição do item
     - `price` (Number) - Preço
     - `category` (Pointer to `Category`) - Ponteiro para a classe `Category`
     - `imageURL` (File) - Arquivo de imagem do item
     - `availability` (Boolean) - Disponibilidade do item
     - `highlighted` (Boolean) - Destaque do item
   - Salve as configurações da classe.

## 1.3 Criar a Classe `IDAutoGen`
   - Clique em "Create a Class" novamente e nomeie a classe como `IDAutoGen`.
   - Adicione os seguintes campos:
     - `objectId` (padrão do Back4App)
     - `className` (String) - Nome da classe para a qual os IDs serão gerados
     - `nextId` (Number) - Próximo ID a ser atribuído
   - Salve as configurações da classe.
