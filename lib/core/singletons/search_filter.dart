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

import '../../data/models/filter.dart';

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
