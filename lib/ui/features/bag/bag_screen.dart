// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/material.dart';

import '/data/models/bag_item.dart';
import '../payment/payment_screen.dart';
import '../shop/product/product_screen.dart';
import '/ui/components/state_messages/state_error_message.dart';
import '/ui/components/state_messages/state_loading_message.dart';
import '/logic/managers/bag_manager.dart';
import '/core/get_it.dart';
import 'bag_controller.dart';
import 'bag_store.dart';
import 'widgets/saller_bag.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  static const routeName = '/bag';

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final store = BagStore();
  late final BagController ctrl;
  final bagManager = getIt<BagManager>();

  @override
  void initState() {
    super.initState();

    ctrl = BagController(store);
  }

  Future<void> _openAd(String adId) async {
    final result = await ctrl.getAdById(adId);
    if (result.isSuccess && result.data != null) {
      final ad = result.data!;
      if (mounted) {
        await Navigator.pushNamed(context, ProductScreen.routeName,
            arguments: ad);
      }
    }
  }

  Future<void> _makePayment(List<BagItemModel> items) async {
    final sessionUrl = await ctrl.createCheckoutSession(items);
    if (sessionUrl != null) {
      if (!mounted) return;
      final result = await Navigator.pushNamed(
        context,
        PaymentScreen.routeName,
        arguments: sessionUrl,
      );

      log(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        centerTitle: true,
        // elevation: 5,
      ),
      body: SingleChildScrollView(
        child: ListenableBuilder(
          listenable: Listenable.merge(
            [bagManager.refreshList, store.state],
          ),
          builder: (context, _) {
            if (store.isLoading) {
              return StateLoadingMessage();
            } else if (store.isSuccess) {
              final List<Widget> sellers = [];
              for (final sellerId in bagManager.sellers) {
                sellers.add(
                  SallerBag(
                    ctrl: ctrl,
                    sallerId: sellerId,
                    sallerName: bagManager.sellerName(sellerId)!,
                    openAd: _openAd,
                    makePayment: _makePayment,
                  ),
                );
              }
              return Column(
                children: [...sellers],
              );
            } else {
              return StateErrorMessage(closeDialog: store.setStateSuccess);
            }
          },
        ),
      ),
    );
  }
}
