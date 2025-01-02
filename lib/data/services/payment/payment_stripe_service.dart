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

import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '/data/models/bag_item.dart';
import 'interfaces/i_payment_service.dart';
import '/core/abstracts/data_result.dart';

class PaymentStripeService implements IPaymentService {
  FirebaseFunctions get _firebaseFuncs {
    if (kDebugMode) {
      const host = '10.0.2.2';
      const port = 5001;
      return FirebaseFunctions.instanceFor(region: 'southamerica-east1')
        ..useFunctionsEmulator(host, port);
    } else {
      return FirebaseFunctions.instanceFor(region: 'southamerica-east1');
    }
  }

  @override
  Future<DataResult<String>> createCheckoutSession(
    List<BagItemModel> items,
  ) async {
    try {
      final callable = _firebaseFuncs.httpsCallable('createCheckoutSession');

      final response = await callable.call({
        'items': items.map((item) => item.toPaymentParameters()).toList(),
      });

      final sessionUrl = response.data['url'] as String?;
      if (sessionUrl == null) {
        throw Exception('Url session return null');
      }
      return DataResult.success(sessionUrl);
    } catch (err) {
      final message =
          'PaymentStripeFunctions.createCheckoutSession: Unexpected error: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  @override
  Future<DataResult<String>> createPaymentIntent(
      List<BagItemModel> items) async {
    try {
      final parameters = {
        'items': items.map((item) => item.toPaymentParameters()).toList(),
      };

      final result = await _firebaseFuncs
          .httpsCallable(
            'createPaymentIntent',
          )
          .call(parameters);

      final clientSecret = result.data['clientSecret'] as String?;

      if (clientSecret == null) {
        throw Exception('clientSecret returned null');
      }

      return DataResult.success(clientSecret);
    } catch (err) {
      final message =
          'PaymentStripeFunctions.createPaymentIntent: Unexpected error: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }
}
