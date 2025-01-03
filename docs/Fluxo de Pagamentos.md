

### ✅ **Fluxo de Pagamentos**

#### 1. **Registrar a Venda no Firebase**

- ✅ Registrar uma nova venda em uma coleção `sales`.
- ✅ Armazenar:
  - ID do comprador e vendedor.
  - Valor da venda.
  - Itens vendidos (adId, quantidade).
  - Status da venda (`payment_successful` inicialmente).
  - Timestamps importantes (data da venda, agendamento de pagamento, status de entrega).
  - `paymentIntentId` para rastreamento no Stripe.
- 🔧 **Refinamento:** Criar um índice no Firestore para garantir buscas eficientes por `buyerId` e `sellerId`.

---

#### 2. **Agendar Pagamento ao Vendedor (Escrow)**

- ✅ Agendar um pagamento em até 30 dias usando um **campo de agendamento** no Firebase (`releasePaymentDate`).
- ✅ Criar um **Cloud Function agendada** que verifica pagamentos pendentes e libera o pagamento se não houver disputas.
- 🔧 **Refinamento:**
  - Armazenar a `transferGroup` no Stripe para vincular pagamentos ao vendedor.
  - Usar um serviço de pagamentos com suporte a **escrow** (Stripe Connect ou similar) para maior segurança.
  - Notificar o vendedor ao liberar o pagamento.

---

#### 3. **Comunicar ao Vendedor para Iniciar a Entrega**

- ✅ Enviar uma notificação ao vendedor no app e via e-mail após o pagamento bem-sucedido.
- ✅ Atualizar o status da venda para `awaiting_shipment`.
- 🔧 **Refinamento:**
  - Registrar quando o vendedor confirma o envio (`shippedAt`).
  - Gerar e salvar um código de rastreamento (trackingCode).

---

#### 4. **Comunicar ao Comprador a Efetivação do Pagamento**

- ✅ Enviar notificação ao comprador sobre o pagamento concluído.
- ✅ Fornecer informações de contato do vendedor e detalhes do pedido.
- ✅ Atualizar o status da venda para `payment_successful`.
- 🔧 **Refinamento:** Incluir o link de rastreamento para acompanhamento.

---

#### 5. **Recebimento pelo Comprador e Feedback**

- ✅ O comprador deve confirmar o recebimento no app.
- ✅ Se o comprador **estiver satisfeito**:
  - ✅ Atualizar status para `completed`.
  - ✅ Liberar o pagamento agendado.
- ✅ Se o comprador **não estiver satisfeito**:
  - ✅ Abrir uma **disputa formal** com um novo documento `disputes`:
    - ID da venda.
    - Descrição do problema.
    - Evidências (fotos, mensagens).
    - Status inicial: `pending`.
  - ✅ Atualizar status da venda para `in_dispute`.
  - ✅ Suspender o pagamento ao vendedor até a resolução.

🔧 **Refinamento:**

- Definir um **prazo de resposta** para o comprador confirmar o recebimento (ex: 7 dias após a entrega).
- Se o comprador não responder dentro do prazo, considerar o pagamento como **liberado automaticamente**.

---

### 🚨 **Cenários Não Observados e Melhorias Adicionais:**

- **Falhas Técnicas:**
  
  - E se o pagamento falhar? (status `payment_failed`, reembolso automático).
  - Reenvio de notificações em caso de erro.

- **Prevenção de Fraudes:**
  
  - Verificação de identidade (KYC) para vendedores.
  - Limite de valores para novos vendedores.

- **Cancelamento e Reembolso:**
  
  - Cancelamento antes do envio (`canceled`).
  - Reembolso parcial se a quantidade entregue for inferior à comprada.

- **Histórico Completo no Firestore:**
  
  - Armazenar um histórico de eventos (`events[]`):
    - `payment_intent_created`
    - `payment_successful`
    - `shipment_confirmed`
    - `payment_released`
    - `dispute_opened`

---

### 📦 **Resumo Final do Fluxo Refinado:**

1. **Venda Confirmada:** `payment_successful`.
2. **Envio do Produto:** `awaiting_shipment`.
3. **Produto Recebido:**
   - ✅ Satisfeito → `completed`.
   - ❌ Insatisfeito → `in_dispute`.
4. **Pagamento ao Vendedor:**
   - ✅ Confirmado → Liberar pagamento.
   - ❌ Disputa aberta → Suspender pagamento e investigar.

Esse fluxo protege ambas as partes, mantém o controle do status e automatiza a maioria dos processos críticos.
