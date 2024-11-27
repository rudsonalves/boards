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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data_managers/bag_manager.dart';
import '../account/account_screen.dart';
import '../../core/singletons/current_user.dart';
import '../../components/drawers/custom_drawer.dart';
import '../../components/collection_views/shop_grid_view/shop_grid_view.dart';
import '../../components/widgets/state_error_message.dart';
import '../../components/widgets/state_loading_message.dart';
import '../../get_it.dart';
import '../bag/bag_screen.dart';
import '../edit_ad/edit_ad_screen.dart';
import '../signin/signin_screen.dart';
import 'shop_controller.dart';
import 'shop_store.dart';
import 'widgets/ads_not_found_message.dart';
import 'widgets/search/search_dialog.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  static const routeName = '/shop';

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  final ctrl = ShopController();
  final store = ShopStore();
  final bagManager = getIt<BagManager>();

  late AnimationController _animationController;
  late Animation<Offset> _fabOffsetAnimation;
  final _scrollController = ScrollController();
  Timer? _timer;

  final currentUser = getIt<CurrentUser>();

  @override
  void initState() {
    super.initState();
    ctrl.init(store);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_scrollListener);
    _animationController.forward();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      _hideFab();
      _resetTimer();
    }
  }

  void _showFab() {
    _animationController.forward();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      _showFab();
    });
  }

  void _hideFab() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    _timer?.cancel();
    store.dispose();

    super.dispose();
  }

  Future<void> _openSearchDialog() async {
    String? result = await showSearch<String>(
      context: context,
      delegate: SearchDialog(),
    );

    if (result != null && result.isEmpty) {
      result = null;
    }
    ctrl.setSearch(result ?? '');
  }

  Widget get titleWidget {
    return (ctrl.searchString.isNotEmpty)
        ? GestureDetector(
            onTap: _openSearchDialog,
            child: LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: constraints.biggest.width,
                child: Text(
                  ctrl.searchString,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        : Text(store.pageTitle.value);
  }

  Future<void> _navToLoginScreen() async {
    if (!ctrl.isLogged) {
      await Navigator.pushNamed(context, SignInScreen.routeName);
    } else {
      Navigator.pushNamed(context, AccountScreen.routeName);
    }
  }

  void _toBagPage() {
    Navigator.pushNamed(context, BagScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: store.pageTitle,
          builder: (context, _) {
            return titleWidget;
          },
        ),
        centerTitle: true,
        // elevation: 5,
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
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: _openSearchDialog,
            onLongPress: ctrl.cleanSearch,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  ctrl.searchFilter.searchNotifier,
                  ctrl.searchFilter.filterNotifier
                ]),
                builder: (context, _) {
                  return Icon(
                    ctrl.haveSearch || ctrl.haveFilter
                        ? Icons.search_off
                        : Icons.search,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        setPageTitle: ctrl.setPageTitle,
        navToLoginScreen: _navToLoginScreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: currentUser.isLogedListernable,
        builder: (context, isLoged, _) => SlideTransition(
          position: _fabOffsetAnimation,
          child: isLoged
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, EditAdScreen.routeName);
                  },
                  backgroundColor:
                      colorScheme.primaryContainer.withOpacity(0.75),
                  icon: const Icon(Icons.camera),
                  label: const Text('Adicionar anúncio'),
                )
              : FloatingActionButton.extended(
                  onPressed: _navToLoginScreen,
                  backgroundColor: colorScheme.tertiaryContainer,
                  icon: const Icon(Icons.login),
                  label: const Text('Faça Login'),
                ),
        ),
      ),
      body: NotificationListener<ScrollStartNotification>(
        onNotification: (scrollNotification) {
          _hideFab();
          _resetTimer();
          return false;
        },
        child: ListenableBuilder(
          listenable: store.state,
          builder: (context, _) => Stack(
            children: [
              // state State Success
              if (ctrl.ads.isEmpty && store.isSuccess) AdsNotFoundMessage(),
              if (ctrl.ads.isNotEmpty && store.isSuccess)
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ShopGridView(
                    ads: ctrl.ads,
                    getMoreAds: ctrl.getMoreAds,
                    scrollController: _scrollController,
                  ),
                ),
              // state State Error
              if (store.isError)
                Positioned.fill(
                  child: StateErrorMessage(
                    closeDialog: ctrl.closeErroMessage,
                  ),
                ),
              // state State Loading
              if (store.isLoading)
                const Positioned.fill(
                  child: StateLoadingMessage(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
