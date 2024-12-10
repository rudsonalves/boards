import 'cart_store.dart';

class CartController {
  late final CartStore store;

  void init(CartStore store) {
    this.store = store;
  }
}
