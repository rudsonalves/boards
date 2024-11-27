import 'package:flutter/material.dart';

import 'cart_controller.dart';
import 'cart_store.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final store = CartStore();
  final ctrl = CartController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
