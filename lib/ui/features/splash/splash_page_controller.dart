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

import '../../../core/singletons/current_user.dart';
import '../../../core/singletons/search_filter.dart';
import '../../../core/singletons/search_history.dart';
import '../../../logic/managers/boardgames_manager.dart';
import '../../../logic/managers/mechanics_manager.dart';
import '../../../core/get_it.dart';
import 'splash_page_store.dart';

class SplashPageController {
  final SplashPageStore store;

  SplashPageController(this.store) {
    _initialized();
  }

  final currentUser = getIt<CurrentUser>();
  final searchFilter = getIt<SearchFilter>();

  Future<void> _initialized() async {
    try {
      store.setStateLoading();
      // Start Boardgames Names Cache
      await getIt<BoardgamesManager>().initialize();
      // Start Mechanics Cache
      await getIt<MechanicsManager>().initialize();
      // Get search history
      getIt<SearchHistory>().init();
      // Check by conectes user
      await currentUser.initialize();
      store.setStateSuccess();
    } catch (err) {
      log(err.toString());
      store.setError('Ocorreu algum problema. Vafor tentar mais tarde.');
    }
  }
}
