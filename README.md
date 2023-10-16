# Easy Pallet API

## Sumário
  * [Descrição do projeto](#descrição-do-projeto)
  * [Funcionalidades](#funcionalidades)
  * [Como rodar a aplicação](#como-rodar-a-aplicação)
  * [Como rodar os testes](#como-rodar-os-testes)
  * [Como executar a análise do código](#como-executar-a-análise-do-código)
  * [Como derrubar a aplicação](#como-derrubar-a-aplicação)
  * [Documentação da API](#documentação-da-api)

## Descrição do projeto

<h4 align="justify"> API desenvolvida para processo seletivo da Easy Pallet </h4>
<p align="justify"> Esta API permite o gerenciamento de informações relacionadas a cargas, listas, produtos e usuários. Sua autenticação é baseado em tokens JWT (JSON Web Tokens), garantindo que apenas usuários autenticados acessem recursos protegidos. </p>

## Funcionalidades

### Autenticação (login)
- [x] POST /api/v1/login

### Cargas (Loads)
- [x] GET /api/v1/loads (Listar todas as cargas com paginação)
- [x] GET /api/v1/loads/:id (Detalhes de uma carga)
- [x] POST /api/v1/loads (Criar uma carga)
- [x] PUT /api/v1/loads/:id (Editar uma carga existente)
- [x] DELETE /api/v1/loads/:id (Excluir uma carga)

### Listas (Orders)
- [x] GET /api/v1/loads/:load_id/orders (Listar todas as listas de uma carga com paginação)
- [x] GET /api/v1/orders/:id (Detalhes de uma lista)
- [x] POST /api/v1/loads/:load_id/orders (Criar uma nova lista para uma carga)
- [x] PUT /api/v1/orders/:id (Editar uma lista existente)
- [x] DELETE /api/v1/orders/:id (Excluir uma lista)

### Produtos (Products)
- [x] GET /api/v1/products (Listar todos os produtos com paginação)
- [x] GET /api/v1/all/products (Listar todos os produtos sem paginação)
- [x] GET /api/v1/products/:id (Detalhes de um produto)
- [x] POST /api/v1/products (Criar um novo produto)
- [x] PUT /api/v1/products/:id (Editar um produto existente)
- [x] DELETE /api/v1/products/:id (Excluir um produto)

### Produtos da Lista (OrderProducts)
- [x] GET /api/v1/orders/:order_id/order_products (Listar produtos de uma lista específica)
- [x] GET /api/v1/order_products/:id (Detalhes de um produto da lista)
- [x] POST /api/v1/orders/:order_id/order_products (Adicionar um novo produto a uma lista)
- [x] PUT /api/v1/order_products/:id (Editar um produto da lista)
- [x] DELETE /api/v1/order_products/:id (Excluir um produto da lista)

### Usuários (Users)

- [x] GET /api/v1/users (Listar todos os usuários com paginação)
- [x] GET /api/v1/users/:id (Detalhes de um usuário)
- [x] POST /api/v1/users (Criar um novo usuário)
- [x] PUT /api/v1/users/:id (Editar um usuário existente)
- [x] DELETE /api/v1/users/:id (Excluir um usuário)

### Importação de Dados

- [x] POST /api/v1/loads/import (Importar dados da planilha de cargas)
- [x] POST /api/v1/products/import (Importar dados da planilha de produtos)
- [x] POST /api/v1/users/import (Importar dados da planilha de usuários)

<div align="center">
:construction: Em desenvolvimento...
</div>

## Como rodar a aplicação

No terminal, clone o projeto:

```
git clone git@github.com:thalis-freitas/easy_pallet_api.git
```

Entre na pasta do projeto:

```
cd easy_pallet_api
```

Certifique-se de que o Docker esteja em execução em sua máquina e construa as imagens:

```
docker compose build
```

Suba os containers:

```
docker compose up -d
```

Acesse o container da aplicação:

```
docker compose exec app bash
```

Crie o banco de dados:

```
rails db:create
```

Execute as migrações:

```
rails db:migrate
```

Crie um usuário:
```
rails db:seed
```

* Dados do usuário criado:

| Login | Senha |
| ----- | ----- |
| user  | pass  |

## Como rodar os testes

```
rspec
```

## Como executar a análise do código

```
rubocop
```

## Como derrubar a aplicação

```
docker compose down
```

## Documentação da API

### Status de resposta possíveis

- `200 OK`: A requisição foi bem sucedida.
- `201 Created`: O registro foi criado com sucesso.
- `401 Unauthorized`: Acesso não autorizado.
- `404 Not Found`: O recurso solicitado não foi encontrado.
- `422 Unprocessable Entity`: Erro de validação de dados, detalhes dos erros são fornecidos no corpo da resposta.
- `500 Internal Server Error`: Erro interno do servidor.

### Parâmetros de consulta para Endpoints com paginação (Opcionais)

| Nome            | Tipo      | Descrição                |
| --------------- | --------- | ------------------------ |
| `page`          | Inteiro   | Número da página desejada. |
| `per_page`      | Inteiro   | Número de cargas por página. |

## Autenticação

### Login de Usuário

**Endpoint: POST /api/v1/login**

Este endpoint permite que um usuário faça login fornecendo seu nome de usuário (login) e senha.

#### Parâmetros de Requisição

| Nome       | Tipo      | Descrição           |
| ---------- | --------- | ------------------- |
| `login`    | String    | Login do usuário.   |
| `password` | String    | A senha do usuário. |

#### Exemplo de Requisição

```json
{
  "user": {
    "login": "user",
    "password": "pass"
  }
}
```

Retorno `200` (Sucesso)

Se o login for bem-sucedido, o endpoint retornará um código de status `200 OK` juntamente com os detalhes do usuário autenticado e um token de acesso.

```json
{
  "user": {
    "id": 3,
    "name": "User",
    "login": "user"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ETUYUOkmfnWsWIvA8iBOkE2s1ZQ0V_zgnG_c4QRrhbg"
}

```

Retorno `422` (Erro de Validação)

Se o login ou a senha forem inválidos, o endpoint retornará um código de status `422 Unprocessable Entity` com informações sobre o erro de validação.

```json
{
  "errors": "Login ou senha inválidos"
}
```

## Cargas

## Listar Todas as Cargas

**Endpoint: GET /api/v1/loads**

Este endpoint permite obter uma lista paginada de todas as cargas registradas no sistema.

#### Exemplo de Requisição

GET /api/v1/loads?page=1&per_page=10

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status `200 OK` juntamente com a lista de cargas e informações de paginação.

```json
{
  "loads": [
    {
      "id": 1,
      "code": "EIG924L4",
      "delivery_date": "2023-10-07"
    },
    {
      "id": 2,
      "code": "S29EBXI0",
      "delivery_date": "2023-10-01"
    }
  ],
  "meta": {
    "current_page": 1,
    "total_items": 2,
    "items_per_page": 10
  }
}
```

## Detalhes de uma Carga

**Endpoint: GET /api/v1/loads/:id**

Este endpoint permite obter detalhes de uma carga específica com base no ID fornecido.

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status 200 OK juntamente com os detalhes da carga solicitada.

```json
{
  "id": 1,
  "code": "EIG924L4",
  "delivery_date": "2023-10-07"
}
```

## Criação de uma Carga

**Endpoint: POST /api/v1/loads**

Este endpoint permite a criação de uma nova carga.

#### Parâmetros de Requisição

| Nome            | Tipo      | Descrição                |
| --------------- | --------- | ------------------------ |
| `code`          | String    | O código da carga.       |
| `delivery_date` | Data      | Data de entrega da carga.|

#### Exemplo de Requisição

```json
{
  "code": "EIG924L4",
  "delivery_date": "2023-10-07"
}
```

Retorno `201` (Sucesso)

Se a carga for criada com sucesso, o endpoint retornará um código de status `201 Created` juntamente com os detalhes da carga criada.

```json
{
  "id": 3,
  "code": "EIG924L4",
  "delivery_date": "2023-10-07"
}
```

Retorno `422` (Erro de Validação)

Se a validação falhar devido a dados inválidos, o endpoint retornará um código de status `422 Unprocessable Entity` juntamente com informações sobre os erros de validação.

```json
{
  "errors": [
    "code": "Código não pode ficar em branco",
    "delivery_date": "Data de entrega não pode ficar em branco"
  ]
}
```

### Editar uma Carga Existente

**Endpoint: PUT /api/v1/loads/:id**

Este endpoint permite a edição de uma carga existente com base no ID fornecido.

#### Exemplo de Requisição

```json
{
  "code": "NOVO-CODIGO",
  "delivery_date": "2023-10-14"
}
```

Retorno `200` (Sucesso)

Se a carga for editada com sucesso, o endpoint retornará um código de status `200 OK` juntamente com os detalhes da carga atualizada.

```json
{
  "id": 1,
  "code": "NOVO-CODIGO",
  "delivery_date": "2023-10-14"
}
```

### Excluir uma carga

**Endpoint: DELETE /api/v1/loads/:id**

Este endpoint permite a exclusão de uma carga com base no ID fornecido.

Retorno `200` (Sucesso)

Se a carga for excluída com sucesso, o endpoint retornará um código de status `200 Ok`.

## Listas

## Listar Todas as Listas de uma Carga

**Endpoint: GET /api/v1/loads/:load_id/orders**

Este endpoint permite obter uma lista paginada com todas as listas de uma carga.

#### Exemplo de Requisição

GET /api/v1/loads/1/orders?per_page=2&page=5

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status `200 OK` juntamente com a lista de listas e informações de paginação.

```json
{
  "orders": [
    {
      "id": 10,
      "code": "WBNPCO3WX",
      "bay": "M8L",
      "load_id": 1
    },
    {
      "id": 11,
      "code": "3GAHSYZC6",
      "bay": "OL4",
      "load_id": 1
    }
  ],
  "meta": {
    "current_page": 5,
    "total_items": 30,
    "items_per_page": 2
  }
}

```

## Detalhes de uma Lista

**Endpoint: GET /api/v1/orders/:id**

Este endpoint permite obter detalhes de uma lista específica com base no ID fornecido.

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status 200 OK juntamente com os detalhes da lista.

```json
{
  "id": 3,
  "code": "WUT414FXL",
  "bay": "FS3"
}
```

## Criação de uma Lista

**Endpoint: POST /api/v1/loads/:load_id/orders**

Este endpoint permite a criação de uma nova lista para uma carga.

#### Parâmetros de Requisição

| Nome   | Tipo      | Descrição         |
| ------ | -------   | ------------------|
| `code` | String    | Código da lista.  |
| `bay`  | String    | Baia da lista.    |

#### Exemplo de Requisição

```json
{
  "code": "WUT414FXL",
  "bay": "FS3"
}
```

Retorno `201` (Sucesso)

Se a lista for criada com sucesso, o endpoint retornará um código de status `201 Created` juntamente com as informações da lista criada.

```json
{
  "id": 3,
  "code": "WUT414FXL",
  "bay": "FS3"
}
```

Retorno `422` (Erro de Validação)

Se a validação falhar devido a dados inválidos, o endpoint retornará um código de status `422 Unprocessable Entity` juntamente com informações sobre os erros de validação.

```json
{
  "errors": [
    "code": "Código não pode ficar em branco",
    "bay": "Baia não pode ficar em branco"
  ]
}
```

### Editar uma Lista Existente

**Endpoint:  PUT /api/v1/orders/:id**

Este endpoint permite a edição de uma lista existente com base no ID fornecido.

#### Exemplo de Requisição

```json
{
  "code": "NOVO-CODIGO",
  "bay": "FS3"
}
```

Retorno `200` (Sucesso)

Se a lista for atualizada com sucesso, o endpoint retornará um código de status `200 OK` juntamente com os dados da lista atualizada.

```json
{
  "id": 1,
  "code": "NOVO-CODIGO",
  "bay": "FS3"
}
```

### Excluir uma lista

**Endpoint: DELETE /api/v1/orders/:id**

Este endpoint permite a exclusão de uma lista com base no ID fornecido.

Retorno `200` (Sucesso)

Se a lista for excluída com sucesso, o endpoint retornará um código de status `200 Ok`.

## Produtos

## Listar Todos os Produtos com Paginação

**Endpoint: GET /api/v1/products**

Este endpoint permite obter uma lista paginada de todos os produtos cadastrados no sistema.

#### Exemplo de Requisição

GET /api/v1/products?per_page=1

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status `200 OK` juntamente com a lista de produtos e informações de paginação.

```json
{
  "products": [
    {
      "id": 1,
      "name": "QUI EXCEPTURI OPTIO ET.",
      "ballast": "76"
    },
  ],
  "meta": {
    "current_page": 1,
    "total_items": 60,
    "items_per_page": 2
  }
}

```

## Listar Todos os Produtos sem Paginação

**Endpoint: GET /api/v1/all/products**

Este endpoint permite obter uma lista com todos os produtos cadastrados no sistema.

#### Exemplo de Requisição

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status `200 OK` juntamente com a lista dos produtos.

```json
[
  {
    "id": 1,
    "name": "CONSEQUATUR QUASI REICIENDIS ET.",
    "ballast": "100"
  },
  {
    "id": 2,
    "name": "EUM EST PERFERENDIS MODI.",
    "ballast": "33"
  },
  {
    "id": 3,
    "name": "DOLORUM EVENIET QUIA VOLUPTATEM.",
    "ballast": "51"
  }
]

```

## Detalhes de um Produto

**Endpoint: GET /api/v1/products/:id**

Este endpoint permite obter detalhes de um produto específico com base no ID fornecido.

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status 200 OK juntamente com os detalhes do produto.

```json
{
  "name": "ULLAM EOS TOTAM MODI",
  "ballast": "16"
}
```

## Criação de um Produto

**Endpoint: POST /api/v1/products**

Este endpoint permite a criação de um novo produto.

#### Parâmetros de Requisição

| Nome      | Tipo   | Descrição           |
| --------- | ------ | ------------------- |
| `name`    | String | O nome do produto.  |
| `ballast` | String | O lastro do produto.|

#### Exemplo de Requisição

```json
{
  "name": "ULLAM EOS TOTAM MODI",
  "ballast": "16"
}
```

Retorno `201` (Sucesso)

Se o produto for criado com sucesso, o endpoint retornará um código de status `201 Created` juntamente com os detalhes do produto criado.

```json
{
  "id": 3,
  "name": "ULLAM EOS TOTAM MODI",
  "ballast": "16"
}
```

Retorno `422` (Erro de Validação)

Se a validação falhar devido a dados inválidos, o endpoint retornará um código de status `422 Unprocessable Entity` juntamente com informações sobre os erros de validação.

```json
{
  "errors": [
    "name":"Nome não pode ficar em branco",
  ]
}
```

### Editar um Produto Existente

**Endpoint: PUT /api/v1/products/:id**

Este endpoint permite a edição de um produto existente com base no ID fornecido.

#### Exemplo de Requisição

```json
{
  "name": "NOVO NOME",
  "ballast": "15"
}
```

Retorno `200` (Sucesso)

Se o produto for atualizado com sucesso, o endpoint retornará um código de status `200 OK` juntamente com os detalhes do produto atualizado.

```json
{
  "id": 3,
  "name": "NOVO NOME",
  "ballast": "15"
}
```

### Excluir um Produto

**Endpoint: DELETE /api/v1/products/:id**

Este endpoint permite a exclusão de um produto com base no ID fornecido.

Retorno `200` (Sucesso)

Se o produto for excluído com sucesso, o endpoint retornará um código de status `200 Ok`.

## Produtos da Lista

## Listar Todos os Produtos de uma Lista

**Endpoint: GET /api/v1/orders/:order_id/order_products**

Este endpoint permite obter uma lista com todos os produtos de uma lista.

#### Exemplo de Requisição

GET /api/v1/orders/1/order_products?per_page=2&page=5

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status `200 OK` juntamente com os produtos da lista.

```json
[
  {
    "id": 1,
    "order_id": 1,
    "product_id": 41,
    "quantity": "229"
  },
  {
    "id": 2,
    "order_id": 1,
    "product_id": 42,
    "quantity": "242"
  }
]

```

## Detalhes de um Produto da Lista

**Endpoint: GET /api/v1/order_products/:id**

Este endpoint permite obter detalhes de um produto da lista específico com base no ID fornecido.

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status 200 OK juntamente com os detalhes do produto da lista.

```json
{
  "product_id": 1,
  "quantity": "5"
}
```

## Criação de um Produto de uma Lista

**Endpoint: POST /api/v1/orders/:order_id/order_products**

Este endpoint permite a criação de um novo produto de uma lista.

#### Parâmetros de Requisição

| Nome         | Tipo      | Descrição               |
| ------------ | -------   | ------------------------|
| `product_id` | Inteiro   | ID do produto.          |
| `quantity`   | String    | Quantidade de produtos. |

#### Exemplo de Requisição

```json
{
  "product_id": 1,
  "quantity": "5"
}

```

Retorno `201` (Sucesso)

Se o produto da lista for criado com sucesso, o endpoint retornará um código de status `201 Created` juntamente com os dados do produto da lista.

```json
{
  "id": 5,
  "order_id":1,
  "product_id": 1,
  "quantity":"5"
}
```

Retorno `422` (Erro de Validação)

Se a validação falhar devido a dados inválidos, o endpoint retornará um código de status `422 Unprocessable Entity` juntamente com informações sobre os erros de validação.

```json
{
  "errors": [
    "quantity": "Quantidade não pode ficar em branco"
    "product_id": "Produto é obrigatório(a)"
  ]
}
```

### Editar um Produto da Lista

**Endpoint:  PUT /api/v1/orders/:id**

Este endpoint permite a edição de um produto de uma lista com base no seu ID.

#### Exemplo de Requisição

```json
{
    "product_id": "1",
    "quantity": "12"
}
```

Retorno `200` (Sucesso)

Se o produto da lista for atualizada com sucesso, o endpoint retornará um código de status `200 OK` juntamente com os dados do produto da lista atualizados.

```json
{
  "id": 5,
  "order_id":1,
  "product_id": "1",
  "quantity": "12"
}
```

### Excluir um Produto de uma Lista

**Endpoint: DELETE /api/v1/order_products/:id**

Este endpoint permite a exclusão de um produto de uma lista com base no ID fornecido.

Retorno `200` (Sucesso)

Se o produto da lista for removido com sucesso, o endpoint retornará um código de status `200 Ok`.

## Usuários

## Listar Todos os Usuários

**Endpoint: GET /api/v1/users**

Este endpoint permite obter uma lista paginada com todos os usuários registrados no sistema.

#### Exemplo de Requisição

GET /api/v1/users?per_page=2&page=3

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status `200 OK` juntamente com a lista de usuários e informações de paginação.

```json
{
  "users": [
    {
      "id": 5,
      "name": "officia",
      "login": "autem24"
    },
    {
      "id": 6,
      "name": "dolores",
      "login": "repellendus30"
    }
  ],
  "meta": {
    "current_page": 3,
    "total_items": 8,
    "items_per_page": 2
  }
}

```

## Detalhes de um Usuário

**Endpoint: GET /api/v1/users/:id**

Este endpoint permite obter detalhes de um usuário com base no ID fornecido.

#### Retorno `200` (Sucesso)

Se a consulta for bem-sucedida, o endpoint retornará um código de status 200 OK juntamente com os detalhes do usuário.

```json
{
  "id": 82,
  "name": "User",
  "login": "user_1999"
}
```

## Cadastro de um Usuário

**Endpoint: POST /api/v1/users**

Este endpoint permite o cadastro de um novo usuário.

#### Parâmetros de Requisição

| Nome         | Tipo   | Descrição           |
| ---------    | ------ | ------------------- |
| `name`       | String | O nome do usuário.  |
| `login`      | String | O login do usuário. |
| `password`   | String | A senha do usuário. |

#### Exemplo de Requisição

```json
{
  "name": "User",
  "login": "user_1999",
  "password": "pass1234"
}
```

Retorno `201` (Sucesso)

Se o usuário for cadastrado com sucesso, o endpoint retornará um código de status `201 Created` juntamente com os detalhes do usuário criado.

```json
{
  "user": {
    "id": 82,
    "name": "User",
    "login": "user_1999"
  }
}
```

Retorno `422` (Erro de Validação)

Se a validação falhar devido a dados inválidos, o endpoint retornará um código de status `422 Unprocessable Entity` juntamente com informações sobre os erros de validação.

```json
{
  "errors": {
    "name": "Nome não pode ficar em branco",
    "login": "Login já está em uso",
    "password": "Senha deve conter, no mínimo, 4 caracteres"
  }
}

```

### Editar uma Usuário

**Endpoint: PUT /api/v1/users/:id**

Este endpoint permite a edição de um usuário com base no ID fornecido.

#### Exemplo de Requisição

```json
{
  "login": "user84",
  "password": "new_password"
}

```

Retorno `200` (Sucesso)

Se o usuário for editado com sucesso, o endpoint retornará um código de status `200 OK` juntamente com os detalhes do usuário.

```json
{
    "id": 84,
    "name": "User",
    "login": "user84"
}

```

### Excluir um usuário

**Endpoint: DELETE /api/v1/users/:id**

Este endpoint permite a exclusão de um usuário com base no ID fornecido.

Retorno `200` (Sucesso)

Se o usuário for removido com sucesso, o endpoint retornará um código de status `200 Ok`.

## Importação de Dados

#### Parâmetros de Requisição

| Nome         | Tipo    | Descrição           |
| ---------    | ------  | ------------------- |
| `file`       | Arquivo | Arquivo XLSX contendo dados de usuários.  |

Retorno `201` (Sucesso)

Se a importação for bem-sucedida, o endpoint retornará um código de status `201 Created` e os dados serão criados com base nos dados do arquivo.

Retorno `422` (Erro de Validação)

Se a validação dos dados do arquivo falhar, devido a formato inválido o endpoint retornará um código de status `422 Unprocessable Entity` juntamente com a mensagem de erro de validação.

```json
{ "error": "Formato de arquivo inválido" }

```

### Importar Dados de Usuários

**Endpoint: POST /api/v1/import/users**

Este endpoint permite a importação de novos usuários a partir de um arquivo XLSX.

### Importar Dados de Produtos

**Endpoint: POST /api/v1/import/products**

Este endpoint permite a importação de novos produtos a partir de um arquivo XLSX.

### Importar Dados de Cargas

**Endpoint: POST /api/v1/import/loads**

Este endpoint permite a importação de novas cargas a partir de um arquivo XLSX.