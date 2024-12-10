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
