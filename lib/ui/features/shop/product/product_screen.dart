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
import 'package:material_symbols_icons/symbols.dart';

import '../../../components/widgets/app_snackbar.dart';
import '../../bag/bag_screen.dart';
import '../../../../logic/managers/bag_manager.dart';
import '../../../../data/models/ad.dart';
import '/core/singletons/current_user.dart';
import '../../../components/widgets/favorite_button.dart';
import '../../../../core/get_it.dart';
import 'message/message_widget.dart';
import 'procuct_store.dart';
import 'product_controller.dart';
import 'widgets/description_product.dart';
import 'widgets/gama_data/game_data_widget.dart';
import 'widgets/image_carousel.dart';
import 'widgets/price_product.dart';
import 'widgets/title_product.dart';
import 'widgets/user_card_product.dart';

const double indent = 0;

class ProductScreen extends StatefulWidget {
  final AdModel ad;

  const ProductScreen({
    super.key,
    required this.ad,
  });

  static const routeName = 'product';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductController ctrl;
  final store = ProcuctStore();
  final bagManager = getIt<BagManager>();

  late final AdModel ad;

  bool get isLogged => getIt<CurrentUser>().isLogged;

  @override
  void initState() {
    super.initState();

    ad = widget.ad;

    ctrl = ProductController(store, ad);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addBag() async {
    await ctrl.addBag();
    if (!mounted) return;
    AppSnackbar.show(
      context,
      title: 'Minha Sacola',
      iconTitle: Symbols.shopping_bag,
      message: '"${ad.title}" foi adicionado a sua sacola',
    );
  }

  void _toBagPage() {
    Navigator.pushNamed(context, BagScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ad.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        elevation: 5,
        actions: [
          ValueListenableBuilder(
            valueListenable: bagManager.itemsCount,
            builder: (context, count, _) {
              return IconButton(
                onPressed: _toBagPage,
                icon: Badge(
                  label: Text(count.toString()),
                  child: Icon(Symbols.shopping_bag_rounded),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ImageCarousel(ad: ad),
                ),
                if (isLogged) FavoriteStackButton(ad: ad),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceProduct(price: ad.price),
                      FilledButton.icon(
                        onPressed: _addBag,
                        icon: Icon(Symbols.shopping_bag_rounded),
                        label: Text('Comprar'),
                      ),
                    ],
                  ),
                  TitleProduct(title: ad.title),
                  Text('Disponível: ${ad.quantity} '
                      'unidade${ad.quantity > 1 ? 's' : ''}'),
                  const Divider(indent: indent, endIndent: indent),
                  DescriptionProduct(description: ad.description),
                  if (ad.boardgameId != null)
                    GameDataWidget(
                      bgId: ad.boardgameId!,
                      indent: indent,
                    ),
                  const Divider(indent: indent, endIndent: indent),
                  UserCard(
                    name: ad.ownerName!,
                    createAt: ad.ownerCreateAt!,
                    address: ad.ownerCity!,
                    rate: ad.ownerScore ?? 0,
                  ),
                  const Divider(indent: indent, endIndent: indent),
                  MessageWidget(
                    adId: ad.id!,
                    ownerId: ad.ownerId!,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
