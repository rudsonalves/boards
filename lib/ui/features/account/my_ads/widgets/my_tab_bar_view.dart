// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../my_ads_controller.dart';
import '../my_ads_store.dart';
import '../../../../components/collection_views/ad_list_view/ad_list_view.dart';
import '../../../../../data/models/ad.dart';

class MyTabBarView extends StatefulWidget {
  final MyAdsController ctrl;
  final ScrollController scrollController;
  final Function(AdModel ad) editAd;
  final Function(AdModel ad) deleteAd;

  const MyTabBarView({
    super.key,
    required this.ctrl,
    required this.scrollController,
    required this.editAd,
    required this.deleteAd,
  });

  @override
  State<MyTabBarView> createState() => _MyTabBarViewState();
}

class _MyTabBarViewState extends State<MyTabBarView> {
  MyAdsController get ctrl => widget.ctrl;
  MyAdsStore get store => ctrl.store;

  @override
  Widget build(BuildContext context) {
    final ads = ctrl.ads;

    if (ads.isEmpty) {
      return Container();
    } else {
      return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          3,
          (tabIndex) => Padding(
            padding: const EdgeInsets.all(8),
            child: AdListView(
              ads: ads,
              getMoreAds: ctrl.getMoreAds,
              scrollController: widget.scrollController,
              enableDismissible: true,
              buttonBehavior: tabIndex != 1 ? true : false,
              editAd: widget.editAd,
              deleteAd: widget.deleteAd,
              updateAdStatus: ctrl.updateAdStatus,
            ),
          ),
        ),
      );
    }
  }
}
