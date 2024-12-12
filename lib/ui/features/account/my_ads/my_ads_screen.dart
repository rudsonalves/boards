import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../data/models/ad.dart';
import '../../edit_ad/edit_ad_screen.dart';
import '../../shop/product/widgets/title_product.dart';
import 'my_ads_controller.dart';
import 'my_ads_store.dart';
import 'widgets/my_tab_bar.dart';
import 'widgets/my_tab_bar_view.dart';
import '../../../components/state_messages/state_error_message.dart';
import '../../../components/state_messages/state_loading_message.dart';
import 'widgets/no_ads_found_card.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  static const routeName = '/myadds';

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  final ctrl = MyAdsController();
  final store = MyAdsStore();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  void _backPage() {
    Navigator.pop(context);
  }

  void _editAd(AdModel ad) async {
    final result = await Navigator.pushNamed(
      context,
      EditAdScreen.routeName,
      arguments: ad,
    ) as AdModel?;
    if (result != null) {
      ctrl.updateAd(result);
    }
  }

  Future<void> _deleteAd(AdModel ad) async {
    final response = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remover Anúncio'),
            icon: const Icon(
              Icons.warning_amber,
              color: Colors.amber,
              size: 80,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Confirma a remoção do anúcio:'),
                TitleProduct(title: ad.title),
              ],
            ),
            actions: [
              FilledButton.tonalIcon(
                onPressed: () => Navigator.pop(context, true),
                label: const Text('Remover'),
                icon: const Icon(Symbols.delete),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ) ??
        false;

    if (response) {
      ctrl.deleteAd(ad);
    }
  }

  Future<void> _addNewAd() async {
    await Navigator.pushNamed(context, EditAdScreen.routeName);
    ctrl.getAds();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      initialIndex: AdStatus.active.index,
      length: AdStatus.values.length - 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Anúncios'),
          centerTitle: true,
          elevation: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _backPage,
          ),
          bottom: MyTabBar(setProductStatus: ctrl.setProductStatus),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addNewAd,
          backgroundColor: colorScheme.primaryContainer.withOpacity(0.75),
          icon: const Icon(Icons.camera),
          label: const Text('Adicionar anúncio'),
        ),
        body: ListenableBuilder(
          listenable: store.state,
          builder: (context, _) {
            if (store.isSuccess) {
              // If Ads if empty show NoAdsFoundCard Widget
              if (ctrl.ads.isEmpty) {
                return NoAdsFoundCard();
              } else {
                // else show Ads
                return MyTabBarView(
                  ctrl: ctrl,
                  scrollController: _scrollController,
                  editAd: _editAd,
                  deleteAd: _deleteAd,
                );
              }
            } else if (store.isLoading) {
              return const StateLoadingMessage();
            }
            return StateErrorMessage(
              closeDialog: ctrl.closeErroMessage,
            );
          },
        ),
      ),
    );
  }
}
