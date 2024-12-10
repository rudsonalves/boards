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
