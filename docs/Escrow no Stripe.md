**Stripe** possui um sistema de **Escrow** implementado através do recurso **Stripe Connect** com a funcionalidade de **Delayed Transfers** (Transferências Atrasadas) e **Destination Charges**.

---

### 📦 **O que é Escrow?**

**Escrow** é um mecanismo de pagamento em que o valor de uma transação é retido temporariamente por um terceiro de confiança (no caso, o Stripe) até que todas as condições acordadas entre as partes sejam cumpridas. Somente após essas condições serem atendidas, o pagamento é liberado ao vendedor.

---

### 🎯 **Como funciona o Escrow no Stripe?**

O **Stripe Connect** permite implementar esse mecanismo de retenção com o uso de **Payment Intents** e **Transfer Groups**. O fluxo típico é:

1. **O comprador realiza o pagamento.**
   
   - Um `PaymentIntent` é criado e o valor é debitado do cartão do comprador.
   - O valor **não é transferido ao vendedor imediatamente**.
   - O valor fica retido em uma "conta" intermediária no Stripe.

2. **O valor fica retido (Delayed Transfer).**
   
   - O valor pago pelo comprador fica "bloqueado" até que o evento desejado ocorra.
   - Você pode definir um prazo (ex: 30 dias) para liberar ou reter o valor.

3. **Condições de Liberação:**
   
   - ✅ **Se o comprador receber o produto e estiver satisfeito:**
     - O valor é liberado ao vendedor com uma `Transfer`.
   - ❌ **Se houver disputa (produto com defeito, não entregue, etc.):**
     - O pagamento é retido até a disputa ser resolvida.
     - O valor pode ser devolvido ao comprador (`Refund`) ou liberado ao vendedor após análise.

---

### 📑 **Recursos Utilizados no Stripe para Implementar Escrow:**

- **PaymentIntent:** Cria e captura o pagamento do comprador.
- **Destination Charges:** Permite processar pagamentos e enviar para contas conectadas (vendedores).
- **Transfer Group:** Associa a transação a um conjunto de transferências, facilitando o rastreamento de pagamentos.
- **Delayed Transfers:** Adia a liberação do pagamento ao vendedor.
- **Refunds:** Em caso de disputas, o valor pode ser reembolsado diretamente ao comprador.

---

### ✅ **Exemplo de Fluxo no Stripe Connect:**

1. **Criar o PaymentIntent:**
   
   ```typescript
   const paymentIntent = await stripe.paymentIntents.create({
    amount: 10000, // Valor em centavos
    currency: 'brl',
    payment_method_types: ['card'],
    capture_method: 'manual',  // Pagamento não capturado imediatamente
    metadata: { orderId: '1234' },
    transfer_group: 'group_order_1234',
   });
   ```

2. **Capturar o Pagamento (Liberar o valor):**
   
   ```typescript
   await stripe.paymentIntents.capture(paymentIntent.id);
   ```

3. **Transferir o Pagamento ao Vendedor (Após a confirmação):**
   
   ```typescript
   await stripe.transfers.create({
    amount: 10000, // Valor total ou parcial
    currency: 'brl',
    destination: 'acct_1234567890',
    transfer_group: 'group_order_1234',
   });
   ```

4. **Reembolso (Em caso de disputa):**
   
   ```typescript
   await stripe.refunds.create({
    payment_intent: paymentIntent.id,
   });
   ```

---

### 📊 **Vantagens de Utilizar Escrow no Stripe:**

- **Segurança:** Garante que o vendedor só receba após a entrega e satisfação do comprador.
- **Automatização:** As transferências e retenções podem ser automatizadas por Cloud Functions.
- **Redução de Disputas:** Melhora a confiança dos compradores ao saber que o valor está protegido.
- **Controle Total:** Permite reembolsos parciais, totais e controle manual da liberação do pagamento.

---

### ⚖️ **Conclusão:**

O **Escrow no Stripe** é uma abordagem ideal para marketplaces, pois protege tanto o comprador quanto o vendedor, garantindo que o valor só seja liberado após o cumprimento das condições acordadas. No seu caso, isso pode ser implementado usando **PaymentIntents** com **Delayed Transfers** e **Transfer Groups**, fornecendo total controle sobre o fluxo de pagamentos.
