import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'payment_store.dart';

class PaymentController {
  late final WebViewController webview;
  late final PaymentStore store;
  late final String preferenceId;
  late final double amount;

  void init(
    BuildContext context, {
    required PaymentStore store,
    required String preferenceId,
    required double amount,
  }) {
    this.store = store;

    this.preferenceId = preferenceId;
    this.amount = amount;

    _initializeController(context);
  }

  Future<void> _initializeController(BuildContext context) async {
    try {
      store.setStateLoading();
      webview = WebViewController()
        // Enable JavaScript for Payment Brick
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            // Can display a progress bar or something similar
            onProgress: (int progress) => log('Loading progress $progress%'),
            onPageStarted: (String url) => log('Page started loading: $url'),
            onPageFinished: (String url) => log('Page loaded: $url'),
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains("success_url")) {
                store.setStateSuccess();
                return NavigationDecision.prevent;
              } else if (request.url.contains("failure_url")) {
                store.setError('Falha no pagemento!');
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onWebResourceError: (WebResourceError error) {
              log('Error loading resource: ${error.description}');
              store.setError('Ocoreu um erro. Tente mais tarde');
            },
          ),
        );

      // Sets the initial URL to be loaded
      String url =
          'https://bgshop.b4a.app/payment_page.html?preferenceId=$preferenceId&amount=${amount.toStringAsFixed(2)}';
      await webview.loadRequest(Uri.parse(url));
      store.setStateSuccess();
    } catch (err) {
      log('Erro ao inicializar o WebView: $err');
      store.setError('Erro ao inicializar a página de pagamento.');
    }
  }
}
