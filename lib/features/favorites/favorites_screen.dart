// Copyright (C) 2024 rudson
//
// This file is part of xlo_mobx.
//
// xlo_mobx is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_mobx is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_mobx.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../components/widgets/state_message.dart';
import '/components/collection_views/shop_grid_view/shop_grid_view.dart';
import '/components/widgets/state_loading_message.dart';
import 'favorites_controller.dart';
import 'favorites_store.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static const routeName = '/favorites';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final store = FavoritesStore();
  late final FavoritesController ctrl;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ctrl = FavoritesController(store);
  }

  void _backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _backPage,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListenableBuilder(
          listenable: store.state,
          builder: (context, _) {
            if (store.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StateLoadingMessage(),
                ],
              );
            } else if (store.isSuccess) {
              if (ctrl.ads.isEmpty) {
                return StateMessage(
                  message: 'Nenhum jogo favoritado no momento.',
                  buttonFunc1: _backPage,
                  buttonText1: 'Voltar',
                  buttonIcon1: Icons.arrow_back_ios_new_rounded,
                );
              } else {
                return Stack(
                  children: [
                    ShopGridView(
                      ads: ctrl.ads,
                      getMoreAds: ctrl.getMoreAds,
                      scrollController: _scrollController,
                    ),
                    if (store.isLoading) const StateLoadingMessage()
                  ],
                );
              }
            } else {
              return StateLoadingMessage();
            }
          },
        ),
      ),
    );
  }
}
