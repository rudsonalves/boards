import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/state_messages/state_error_message.dart';
import 'payment_controller.dart';
import 'payment_store.dart';

class PaymentScreen extends StatefulWidget {
  final String preferenceId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.preferenceId,
    required this.amount,
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
      preferenceId: widget.preferenceId,
      amount: widget.amount,
    );
  }

  @override
  void dispose() {
    store.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento'),
      ),
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, value, _) {
          if (store.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          if (store.isSuccess) {
            return WebViewWidget(controller: ctrl.webview);
          }
          if (store.isError) {
            StateErrorMessage(
              message: store.errorMessage,
              closeDialog: store.setStateSuccess,
            );
          }
          return Container();
        },
      ),
    );
  }
}
