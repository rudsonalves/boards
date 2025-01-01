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

import 'dart:developer';

import '/core/abstracts/data_result.dart';
import '../../../../data/models/bg_name.dart';
import '../../../../data/models/boardgame.dart';
import '/core/singletons/current_user.dart';
import '../../../../core/get_it.dart';
import '../../../../logic/managers/boardgames_manager.dart';
import 'boardgames_store.dart';

class BoardgamesController {
  late final BoardgamesStore store;

  final bgManager = getIt<BoardgamesManager>();
  final user = getIt<CurrentUser>();
  final List<BGNameModel> _filteredBGs = [];
  String _search = '';
  String? _selectedBGId;

  bool get isAdmin => user.isAdmin;
  List<BGNameModel> get bgs => bgManager.bgList;
  String get search => _search;
  List<BGNameModel> get filteredBGs => _filteredBGs;
  String? get selectedBGId => _selectedBGId;

  void init(BoardgamesStore store) {
    this.store = store;

    _updateSearchFilter('');
  }

  closeError() {
    store.setStateSuccess();
  }

  Future<void> addBG() async {
    try {
      store.setStateLoading();
      _updateSearchFilter('');
      store.notifiesUpadteBGList();
      await Future.delayed(const Duration(milliseconds: 50));
      store.setStateSuccess();
    } catch (err) {
      store.setError('Ocorreu um erro. Tente mais tarde.');
    }
  }

  Future<bool> removeBg(BGNameModel bgName) async {
    store.setStateLoading();
    final result = await getIt<BoardgamesManager>().delete(bgName.id!);
    if (result.isFailure) {
      log(result.error.toString());
      return false;
    }
    store.setStateSuccess();
    return true;
  }

  Future<void> changeSearchName(String fsearch) async {
    store.setStateLoading();
    _updateSearchFilter(fsearch);
    await Future.delayed(const Duration(milliseconds: 50));
    store.setStateSuccess();
  }

  bool isSelected(BGNameModel bg) => bg.id == _selectedBGId;

  void _updateSearchFilter(String fsearch) {
    _search = fsearch.trim();
    _filteredBGs.clear();
    _filteredBGs.addAll(bgs
        .where(
          (item) => item.name!.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList());
  }

  Iterable<BGNameModel> suggestionsList(String search) {
    final searchBy = search.toLowerCase().trim();
    if (searchBy.trim().isNotEmpty) {
      final suggestionsBGs = bgs.where(
        (bg) => bg.name!.toLowerCase().contains(searchBy.toLowerCase()),
      );
      return suggestionsBGs;
    }
    return [];
  }

  void selectBGId(BGNameModel bg) {
    store.setStateLoading();
    _selectedBGId = (_selectedBGId == bg.id) ? null : bg.id;
    store.setStateSuccess();
  }

  Future<DataResult<BoardgameModel?>> getBoardgameSelected(
      [String? bgId]) async {
    final id = bgId ?? _selectedBGId;
    if (id == null) {
      return DataResult.failure(const GenericFailure());
    }

    return await bgManager.getBoardgameId(id);
  }
}
