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

// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../../data/models/ad.dart';
import '../../../../data/models/bag_item.dart';
import '../../../../logic/managers/bag_manager.dart';
import '../../../../core/get_it.dart';
import 'procuct_store.dart';

class ProductController {
  final ProcuctStore store;
  final AdModel ad;

  final bagManager = getIt<BagManager>();

  ProductController(this.store, this.ad);

  Future<void> addBag() async {
    try {
      store.setStateLoading();
      final item = BagItemModel(
        ad: ad,
        title: ad.title,
        description: ad.description,
        unitPrice: ad.price,
      );
      await bagManager.addItem(item);
      store.setStateSuccess();
    } catch (err) {
      store.setError("Ocorreu um erro. Tente mais tarde.");
    }
  }
}
