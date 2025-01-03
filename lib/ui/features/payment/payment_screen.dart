// Copyright (C) 2025 Rudson Alves
//
// This file is part of boards.
//
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/data/models/bag_item.dart';
import '/ui/components/buttons/big_button.dart';
import '/ui/components/widgets/app_snackbar.dart';
import '/core/theme/app_text_style.dart';
import 'payment_controller.dart';
import 'payment_store.dart';

class PaymentScreen extends StatefulWidget {
  final List<BagItemModel> items;

  const PaymentScreen({
    super.key,
    required this.items,
  });

  static const routeName = '/payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ctrl = PaymentController();
  final store = PaymentStore();

  @override
  void initState() {
    super.initState();

    ctrl.init(
      context,
      store: store,
      items: widget.items,
    );
  }

  @override
  void dispose() {
    store.dispose();

    super.dispose();
  }

  Future<void> _payment() async {
    final result = await ctrl.startPayment();

    if (result) {
      if (!mounted) return;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        AppSnackbar.show(
          context,
          message: 'Seu pagamento está processando.',
        );
      });
    } else {
      if (!mounted) return;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        AppSnackbar.show(
          context,
          message: 'Ocorreu um erro. Tente novamente mais tarde',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: store.state,
            builder: (context, _) {
              if (store.isError) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  AppSnackbar.show(
                    context,
                    message: store.errorMessage ??
                        'Ocorreu um erro. Tente mais tarde',
                  );
                });
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    'Vendido por: ${ctrl.items[0].ownerName}'
                    ' [⛦ ${ctrl.items[0].score == 0 ? '-' : ctrl.items[0].score}]',
                    style: AppTextStyle.font18SemiBold,
                  ),
                  Text(
                    'Itens do Carrinho:',
                    style: AppTextStyle.font18SemiBold,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: ctrl.items.length,
                    itemBuilder: (_, index) {
                      final item = ctrl.items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(
                          '${item.quantity} x'
                          ' R\$ ${item.unitPrice.toStringAsFixed(2)}',
                        ),
                        trailing: Text(
                          'R\$ ${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                          style: AppTextStyle.font16Bold,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Total:',
                      style: AppTextStyle.font18Bold,
                    ),
                    trailing: Text(
                      'R\$ ${ctrl.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyle.font18Bold,
                    ),
                  ),
                  Divider(),
                  Text(
                    'Selecione a forma de Pagamento:',
                    style: AppTextStyle.font16SemiBold,
                  ),
                  ValueListenableBuilder(
                    valueListenable: store.paymentType,
                    builder: (context, paymentType, _) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Cartão'),
                          leading: Radio<PaymentType>(
                            value: PaymentType.card,
                            groupValue: paymentType,
                            onChanged: store.setPaymentType,
                          ),
                          onTap: () => store.setPaymentType(PaymentType.card),
                        ),
                        ListTile(
                          title: Text('Boleto'),
                          leading: Radio<PaymentType>(
                            value: PaymentType.boleto,
                            groupValue: paymentType,
                            onChanged: store.setPaymentType,
                          ),
                          onTap: () => store.setPaymentType(PaymentType.boleto),
                        ),
                        ListTile(
                          title: Text('Pix'),
                          leading: Radio<PaymentType>(
                            value: PaymentType.pix,
                            groupValue: paymentType,
                            onChanged: store.setPaymentType,
                          ),
                          onTap: () => store.setPaymentType(PaymentType.pix),
                        ),
                      ],
                    ),
                  ),
                  BigButton(
                    onPressed: _payment,
                    icon: store.isLoading
                        ? SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator())
                        : Icon(Icons.payment, size: 26),
                    label: 'Seguir para o Pagamento',
                    color: Colors.lightGreen,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
