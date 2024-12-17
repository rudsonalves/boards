import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/core/singletons/app_settings.dart';
import '/core/get_it.dart';
import 'payment_store.dart';

class PaymentController {
  late final WebViewController webview;
  late final PaymentStore store;

  final app = getIt<AppSettings>();

  final stripe = Stripe.instance;

  void init(
    BuildContext context, {
    required PaymentStore store,
  }) {
    this.store = store;
  }
}
