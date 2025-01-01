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
