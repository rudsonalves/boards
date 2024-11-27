import 'package:flutter/material.dart';

import '/core/state/state_store.dart';
import '../../core/config/app_info.dart';
import '../../core/singletons/search_filter.dart';
import '../../get_it.dart';

class ShopStore extends StateStore {
  final searchFilter = getIt<SearchFilter>();

  final ValueNotifier<String> pageTitle = ValueNotifier<String>(AppInfo.name);

  ValueNotifier<bool> get filterNotifier => searchFilter.filterNotifier;

  ValueNotifier<String> get searchNotifier => searchFilter.searchNotifier;

  void setPageTitle(String value) {
    pageTitle.value = value;
  }

  @override
  void dispose() {
    pageTitle.dispose();
    searchFilter.dispose();

    super.dispose();
  }
}
