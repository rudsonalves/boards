// Copyright (C) 2024 Rudson Alves
// 
// This file is part of bgbazzar.
// 
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

// Importa axios para fazer requisições HTTP
const axios = require('axios');

// createPaymentPreference
// Criar uma preferência de pagamento utilizando a API do Mercado Pago. Retorna o ID da 
// preferência gerada para ser usado no Payment Brick.
//
// Parâmetros:
//  - `items`(Array): Lista de objetos que representam os itens a serem comprados, contendo:
//    - `title`(String): Nome do item.
//    - `quantity`(Number): Quantidade do item.
//    - `unit_price`(Number): Preço unitário do item.
//  - `userEmail`(String): Email do comprador.
//
// Fluxo da Função:
//  1. Os itens são formatados no formato esperado pela API do Mercado Pago.
//  2. Faz uma requisição `POST` para a API do Mercado Pago com:
//    - Lista de itens.
//    - Email do comprador.
//  3. Retorna o `preferenceId` gerado pela API.
//  4. Trata erros e os registra no console.
//
// Erro Potencial:
//  - Se a API do Mercado Pago retornar um erro, a mensagem será exibida no console.
Parse.Cloud.define("createPaymentPreference", async (request) => {
  // Obtém os parâmetros do request
  const { items, userEmail } = request.params;

  try {
    // Constrói a lista de itens para a preferência de pagamento no formato esperado pela API do Mercado Pago
    const formattedItems = items.map(item => ({
      title: item.title,
      quantity: item.quantity,
      currency_id: "BRL",
      unit_price: item.unit_price
    }));

    // Obtém o Access Token da variável de ambiente
    const accessToken = process.env.MERCADO_PAGO_ACCESS_TOKEN;
    if (!accessToken) {
      throw new Error("Access token not configured for Mercado Pago.");
    }

    // Faz a requisição POST para a API do Mercado Pago para criar a preferência de pagamento
    const response = await axios.post(
      'https://api.mercadopago.com/checkout/preferences',
      {
        items: formattedItems,
        payer: {
          email: userEmail // Email do comprador
        }
      },
      {
        headers: {
          'Authorization': `Bearer ${accessToken}` // Inclui o Bearer
        }
      }
    );

    // Retorna o ID da preferência gerada para ser usado no Payment Brick
    return { preferenceId: response.data.id };

  } catch (error) {
    // Tratamento de erro caso a requisição falhe
    console.error('Erro ao criar a preferência:', {
      message: error.message,
      response: error.response ? error.response.data : null,
      stack: error.stack
    });
    throw new Error('Erro ao criar a preferência de pagamento.');
  }
});

// updateStockAndStatus: 
// Atualizar o estoque de itens e alterar o status para "vendido"(`sold`) quando o 
// estoque chegar a zero.
// 
// Parâmetros:
//  - `items`(Array): Lista de objetos contendo:
//    - `objectId`(String): ID do item no Parse Server.
//    - `quantity`(Number): Quantidade comprada.
//
// Fluxo da Função:
//  1. Recupera os itens correspondentes no Parse Server usando os `objectId`s fornecidos.
//  2. Para cada item:
//    - Verifica se o estoque atual é suficiente.
//    - Reduz o estoque pela quantidade comprada.
//    - Define o status como "vendido"(`sold`) se o estoque chegar a zero.
//  3. Salva todos os itens atualizados no Parse Server.
//
// Erros Potenciais:
//  - Estoque insuficiente para algum item.
//  - Falha ao salvar os itens atualizados.
Parse.Cloud.define("updateStockAndStatus", async (request) => {
  const itemsToPurchase = request.params.items; // Array de objetos { objectId: "id", quantity: quantidade }

  const itemIds = itemsToPurchase.map(item => item.objectId);
  const query = new Parse.Query("AdsSale");
  query.containedIn("objectId", itemIds);

  const items = await query.find({ useMasterKey: true });

  // Armazena os itens a serem atualizados
  const itemsToUpdate = [];

  for (const item of items) {
    const itemId = item.id;
    const requestedQuantity = itemsToPurchase.find(i => i.objectId === itemId).quantity;
    const currentStock = item.get("quantity");

    if (currentStock >= requestedQuantity) {
      // Decrementa o estoque e verifica se deve alterar o status para "sold"
      item.increment("quantity", -requestedQuantity);

      if (item.get("quantity") === 0) {
        item.set("status", 2); // Define o status para "sold"
      }

      itemsToUpdate.push(item);
    } else {
      // Retorna erro se o estoque for insuficiente para algum item
      return { success: false, message: "Insufficient stock", itemId, currentStock };
    }
  }

  // Se tudo está ok, atualiza os itens no Parse Server
  await Parse.Object.saveAll(itemsToUpdate, { useMasterKey: true });
  return { success: true, message: "Stock updated successfully" };
});

// afterSave para Parse.User
// Adicionar automaticamente um novo usuário ao role`user`.
//
// Fluxo da Função:
//  1. Verifica se o evento é de criação de usuário (não atualização).
//  2. Busca o role `user` no Parse Server.
//  3. Adiciona o novo usuário ao role `user` por meio da relação `users`.
//  4. Salva o role com a relação atualizada.
//
// Erros Potenciais:
//  - Role`user` não encontrado.
//  - Falha ao salvar o role atualizado.
Parse.Cloud.afterSave(Parse.User, async (request) => {
  const user = request.object;

  // Verifique se é uma criação de usuário (e não uma atualização)
  if (!user.existed()) {
    try {
      // Busca o papel "user"
      const roleQuery = new Parse.Query(Parse.Role);
      roleQuery.equalTo("name", "user");
      const role = await roleQuery.first({ useMasterKey: true });

      if (!role) {
        throw new Error('Role "user" not found.');
      }

      // Adiciona o novo usuário ao papel "user"
      const relation = role.relation("users");
      relation.add(user);

      // Salva o papel
      await role.save(null, { useMasterKey: true });

      console.log(`User ${user.id} successfully added to role "user".`);
    } catch (error) {
      console.error(
        `Failed to add user ${user.id} to role "user": ${error.message}`
      );
    }
  }
});

// beforeSave para Boardgame
// Permitir apenas que usuários do role `admin` criem ou editem registros na tabela `Boardgame`.
//
// Fluxo da Função:
//  1. Verifica se o usuário está autenticado.
//  2. Confirma se o usuário pertence ao role `admin`.
//  3. Bloqueia a operação se:
//    - O usuário não for admin e estiver tentando criar um novo registro.
//    - O usuário não for admin e tentar modificar um registro existente.

// Erros Potenciais:
//  - Usuário não autenticado.
//  - Usuário não autorizado a criar ou editar registros.
Parse.Cloud.beforeSave("Boardgame", async (request) => {
  // Permitir automaticamente se o useMasterKey estiver habilitado
  if (request.master) {
    console.log("MasterKey detected, skipping restrictions for beforeSave.");
    return;
  }

  const user = request.user;

  if (!user) {
    throw new Parse.Error(101, "User not authenticated.");
  }

  // Verificar se o usuário pertence ao role "admin"
  const roleQuery = new Parse.Query(Parse.Role);
  roleQuery.equalTo("name", "admin");
  roleQuery.equalTo("users", user);

  const isAdmin = await roleQuery.first({ useMasterKey: true });

  // Bloquear se não for admin e estiver tentando criar/editar
  if (!isAdmin && request.object.isNew()) {
    throw new Parse.Error(403, "Only admins can create new Boardgame objects.");
  }

  if (!isAdmin && request.object.dirtyKeys().length > 0) {
    throw new Parse.Error(403, "Only admins can modify Boardgame objects.");
  }

  console.log(
    `Boardgame ${request.object.id || "new"} saved by user ${user.id
    }, role: ${isAdmin ? "admin" : "user"}.`
  );
});

// beforeDelete para Boardgame
// Permitir que apenas usuários do role `admin` excluam registros na tabela`Boardgame`.
//
// Fluxo da Função:
//  1. Verifica se o usuário está autenticado.
//  2. Confirma se o usuário pertence ao role`admin`.
//  3. Bloqueia a operação se o usuário não for admin.
//
// Erros Potenciais:
//  - Usuário não autenticado.
//  - Usuário não autorizado a excluir registros.
Parse.Cloud.beforeDelete("Boardgame", async (request) => {
  // Permitir automaticamente se o useMasterKey estiver habilitado
  if (request.master) {
    console.log("MasterKey detected, skipping restrictions for beforeDelete.");
    return;
  }

  const user = request.user;

  if (!user) {
    throw new Parse.Error(101, "User not authenticated.");
  }

  // Verificar se o usuário pertence ao role "admin"
  const roleQuery = new Parse.Query(Parse.Role);
  roleQuery.equalTo("name", "admin");
  roleQuery.equalTo("users", user);

  const isAdmin = await roleQuery.first({ useMasterKey: true });

  // Bloquear exclusão se não for admin
  if (!isAdmin) {
    throw new Parse.Error(403, "Only admins can delete Boardgame objects.");
  }

  console.log(`Boardgame ${request.object.id} deleted by admin ${user.id}.`);
});

// beforeSave para AdsSale
// Validar a referência para um `Boardgame` ao salvar um anúncio(`AdsSale`).
//
// Fluxo da Função:
//  1. Verifica se o usuário está autenticado.
//  2. Garante que um `Boardgame` seja referenciado no anúncio.
//  3. Valida se o `Boardgame` referenciado existe no Parse Server.
//
// Erros Potenciais:
//  - Usuário não autenticado.
//  - Referência para um `Boardgame` ausente ou inválida.

Parse.Cloud.beforeSave("AdsSale", async (request) => {
  // Permitir automaticamente se o useMasterKey estiver habilitado
  if (request.master) {
    console.log("MasterKey detected, skipping restrictions for beforeDelete.");
    return;
  }

  const ad = request.object;
  const user = request.user;

  if (!user) {
    throw new Parse.Error(101, "User not authenticated.");
  }

  // Verificar se há um Boardgame referenciado
  const boardgame = ad.get("boardgame");

  if (boardgame) {
    // Validar o Boardgame referenciado
    const boardgameQuery = new Parse.Query("Boardgame");
    boardgameQuery.equalTo("objectId", boardgame.id);
    const fetchedBoardgame = await boardgameQuery.first({ useMasterKey: true });

    if (!fetchedBoardgame) {
      throw new Parse.Error(103, "Referenced Boardgame not found.");
    }

    console.log(
      `Boardgame ${fetchedBoardgame.id} validated successfully for AdsSale.`
    );
  } else {
    console.log("No Boardgame reference provided. Skipping validation.");
  }

  // Permitir a operação de salvar o AdsSale
});
