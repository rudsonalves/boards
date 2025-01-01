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
import 'package:webview_flutter/webview_flutter.dart';

import 'payment_controller.dart';
import 'payment_store.dart';

class PaymentScreen extends StatefulWidget {
  final String sessionUrl;

  const PaymentScreen({
    super.key,
    required this.sessionUrl,
  });

  static const routeName = '/payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ctrl = PaymentController();
  final store = PaymentStore();
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    ctrl.init(
      context,
      store: store,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            // Caso você queira fazer algo ao iniciar o carregamento de uma págin
          },
          onPageFinished: (url) {
            // Caso queira fazer algo quando a página carregar completamente
          },
          onNavigationRequest: (request) {
            // Se quiser interceptar a navegação, por exemplo, quando redirecionar para success_url
            if (request.url.contains('https://exemplo.com/sucesso')) {
              // A página de sucesso da compra: você pode fechar a WebView ou mostrar mensagem de sucesso.
              Navigator.pop(context, 'payment_success');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.sessionUrl));
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
      body: WebViewWidget(controller: _controller),
    );
  }
}
