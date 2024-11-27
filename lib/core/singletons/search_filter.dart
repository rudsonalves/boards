import 'package:flutter/material.dart';

import '../models/filter.dart';

class SearchFilter {
  final _search = ValueNotifier<String>('');

  String get searchString => _search.value;
  set searchString(String value) => _search.value = value;
  ValueNotifier<String> get searchNotifier => _search;

  final _filter = FilterModel();
  final _filterNotifier = ValueNotifier<bool>(false);
  FilterModel get filter => _filter;
  ValueNotifier<bool> get filterNotifier => _filterNotifier;
  bool get haveFilter => _filter != FilterModel();

  void updateFilter(FilterModel newFilter) {
    if (newFilter != _filter) {
      _filter.setFilter(newFilter);
      _filterNotifier.value = !_filterNotifier.value;
    }
  }

  dispose() {
    _search.dispose();
    _filterNotifier.dispose();
  }
}
