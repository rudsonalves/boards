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

import 'package:boards/core/singletons/current_user.dart';
import 'package:boards/data/models/payment_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '/core/abstracts/data_result.dart';
import '/data/services/payment/interfaces/i_payment_service.dart';
import '/data/models/bag_item.dart';
import '/core/singletons/app_settings.dart';
import '/core/get_it.dart';
import 'payment_store.dart';

class PaymentController {
  late final PaymentStore store;
  late final List<BagItemModel> items;

  final _paymentService = getIt<IPaymentService>();
  String? _clientSecret;

  String? get clientSecret => _clientSecret;

  final app = getIt<AppSettings>();
  final user = getIt<CurrentUser>();

  final stripe = Stripe.instance;

  void init(
    BuildContext context, {
    required PaymentStore store,
    required List<BagItemModel> items,
  }) {
    this.store = store;
    this.items = items;
  }

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + (item.quantity * item.unitPrice));

  Future<DataResult<String>> startPayment() async {
    store.setStateLoading();
    final pay = PaymentDataModel(
      buyerId: user.userId,
      sellerId: items.first.ownerId,
      items: items,
    );
    final result = await _paymentService.createPaymentIntent(pay);

    if (result.isSuccess) {
      _clientSecret = result.data;
      store.setStateSuccess();
    } else {
      store.setError(result.error?.message ?? 'unknow error');
    }

    return result;
  }
}
