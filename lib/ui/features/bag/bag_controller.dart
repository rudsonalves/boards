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

import '/data/services/payment/interfaces/i_payment_service.dart';
import '/core/abstracts/data_result.dart';
import '/data/models/ad.dart';
import '/data/models/bag_item.dart';
import '/logic/managers/ads_manager.dart';
import '/logic/managers/bag_manager.dart';
import '/core/get_it.dart';
import 'bag_store.dart';

class BagController {
  final BagStore store;
  final bagManager = getIt<BagManager>();
  final adManager = getIt<AdsManager>();
  final payment = getIt<IPaymentService>();

  Set<BagItemModel> items(String sellerId) => bagManager.bagBySeller[sellerId]!;

  BagController(this.store) {
    initialize();
  }

  Future<void> initialize() async {
    store.setStateLoading();
    Future.delayed(const Duration(milliseconds: 50));
    store.setStateSuccess();
  }

  Future<DataResult<AdModel?>> getAdById(String adId) async {
    store.setStateLoading();
    final result = await adManager.getAdById(adId);
    store.setStateSuccess();
    return result;
  }

  Future<String?> createPaymentIntent(List<BagItemModel> items) async {
    try {
      store.setStateLoading();
      final result = await payment.createPaymentIntent(items);
      if (result.isFailure) {
        throw Exception(
            'makePayment erro: ${result.error?.toString() ?? 'unknow error!'}');
      }
      store.setStateSuccess();
      return result.data!;
    } catch (err) {
      store.setError('Ocorreu um erro. Tente mais tarde.');
      return null;
    }
  }

  Future<String?> createCheckoutSession(List<BagItemModel> items) async {
    try {
      store.setStateLoading();
      final result = await payment.createCheckoutSession(items);
      if (result.isFailure || result.data == null) {
        store.setError('Ocorreu um erro. Tente maios tarde.');
        return null;
      }
      store.setStateSuccess();
      return result.data!;
    } catch (err) {
      store.setError('Ocorreu um erro. Tente mais tarde.');
      return null;
    }
  }

  double calculateAmount(List<BagItemModel> items) {
    return items.fold(0, (sum, item) => sum + item.quantity * item.unitPrice);
  }
}
