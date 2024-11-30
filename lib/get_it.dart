import 'dart:developer';

import 'package:get_it/get_it.dart';

import 'data_managers/ad_manager.dart';
import 'data_managers/bag_manager.dart';
import 'repository/app_data/share_preferences/app_share_preferences_repository.dart';
import 'repository/app_data/interfaces/i_app_preferences_repository.dart';
import 'core/singletons/app_settings.dart';
import 'core/singletons/current_user.dart';
import 'core/singletons/search_filter.dart';
import 'core/singletons/search_history.dart';
import 'data_managers/addresses_manager.dart';
import 'data_managers/boardgames_manager.dart';
import 'data_managers/favorites_manager.dart';
import 'data_managers/mechanics_manager.dart';
import 'repository/data/firebase/fb_address_repository.dart';
import 'repository/data/firebase/fb_user_repository.dart';
import 'repository/data/interfaces/i_ad_repository.dart';
import 'repository/data/interfaces/i_address_repository.dart';
import 'repository/data/interfaces/i_boardgame_repository.dart';
import 'repository/data/interfaces/i_favorite_repository.dart';
import 'repository/data/interfaces/i_mechanic_repository.dart';
import 'repository/data/interfaces/i_user_repository.dart';
import 'repository/data/parse_server/ps_boardgame_repository.dart';
import 'repository/data/parse_server/ps_ad_repository.dart';
import 'repository/data/parse_server/ps_favorite_repository.dart';
import 'repository/data/parse_server/ps_mechanics_repository.dart';
import 'repository/local_data/interfaces/i_local_bag_item_repository.dart';
import 'repository/local_data/sqlite/bag_item_repository.dart';
import 'repository/local_data/sqlite/bg_names_repository.dart';
import 'repository/local_data/interfaces/i_bg_names_repository.dart';
import 'repository/local_data/interfaces/i_local_mechanic_repository.dart';
import 'repository/local_data/sqlite/mechanic_repository.dart';
import 'services/parse_server/parse_server_server.dart';
import 'store/database/database_manager.dart';
import 'store/stores/bag_item_store.dart';
import 'store/stores/bg_names_store.dart';
import 'store/stores/interfaces/i_bag_item_store.dart';
import 'store/stores/interfaces/i_bg_names_store.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  try {
    // Singletons
    getIt.registerSingleton<IAppPreferencesRepository>(
        AppSharePreferencesRepository());
    getIt.registerSingleton<AppSettings>(AppSettings());

    // Lazy Singletons
    getIt.registerLazySingleton<ParseServerService>(() => ParseServerService());
    getIt.registerLazySingleton<MechanicsManager>(() => MechanicsManager());
    getIt.registerLazySingleton<CurrentUser>(() => CurrentUser());
    getIt.registerLazySingleton<FavoritesManager>(() => FavoritesManager());
    getIt.registerLazySingleton<AddressesManager>(() => AddressesManager());
    getIt.registerLazySingleton<SearchFilter>(() => SearchFilter());
    getIt.registerLazySingleton<SearchHistory>(() => SearchHistory());

    getIt.registerLazySingleton<DatabaseManager>(() => DatabaseManager());
    getIt.registerLazySingleton<BoardgamesManager>(() => BoardgamesManager());
    getIt.registerLazySingleton<AdManager>(() => AdManager());

    // Parse Server Repositories
    getIt.registerFactory<IUserRepository>(() => FbUserRepository());
    getIt.registerFactory<IMechanicRepository>(() => PSMechanicsRepository());
    getIt.registerFactory<IAdRepository>(() => PSAdRepository());
    getIt.registerFactory<IBoardgameRepository>(() => PSBoardgameRepository());
    getIt.registerFactory<IAddressRepository>(() => FbAddressRepository());
    getIt.registerFactory<IFavoriteRepository>(() => PSFavoriteRepository());
    getIt.registerFactory<ILocalBagItemRepository>(
        () => SqliteBagItemRepository());

    // SQFLite Store
    getIt.registerFactoryAsync<IBgNamesStore>(() async {
      final store = BGNamesStore();
      await store.initialize();
      return store;
    });
    getIt.registerFactoryAsync<IBagItemStore>(() async {
      final store = BagItemStore();
      await store.initialize();
      return store;
    });

    // Local SqfLite Repositories
    getIt.registerFactoryAsync<IBgNamesRepository>(() async {
      final repository = SqliteBGNamesRepository();
      await repository.initialize();
      return repository;
    });
    getIt.registerFactoryAsync<ILocalMechanicRepository>(() async {
      final repository = SqliteMechanicRepository();
      await repository.initialize();
      return repository;
    });

    // Cart Manager
    getIt.registerLazySingleton<BagManager>(() => BagManager());
  } catch (err) {
    log('GetIt Locator Error: $err');
  }
}

void disposeDependencies() {
  getIt<SearchFilter>().dispose();
  getIt<SearchFilter>().dispose();
  getIt<FavoritesManager>().dispose();
  getIt<CurrentUser>().dispose();
  getIt<AppSettings>().dispose();
  getIt<BagManager>().dispose();
}
