import 'dart:developer';

import 'package:get_it/get_it.dart';

import '../data/services/firebase/firebase_messaging_service.dart';
import '../data/repository/firebase/fb_message_repository.dart';
import '../data/repository/interfaces/remote/i_message_repository.dart';
import '../logic/managers/ads_manager.dart';
import '../logic/managers/bag_manager.dart';
import '../data/repository/app_data/app_share_preferences_repository.dart';
import '../data/repository/interfaces/remote/i_app_preferences_repository.dart';
import '../logic/managers/messages_manager.dart';
import 'singletons/app_settings.dart';
import 'singletons/current_user.dart';
import 'singletons/search_filter.dart';
import 'singletons/search_history.dart';
import '../logic/managers/addresses_manager.dart';
import '../logic/managers/boardgames_manager.dart';
import '../logic/managers/favorites_manager.dart';
import '../logic/managers/mechanics_manager.dart';
import '../data/repository/firebase/fb_address_repository.dart';
import '../data/repository/firebase/fb_ads_repository.dart';
import '../data/repository/firebase/fb_boardgame_repository.dart';
import '../data/repository/firebase/fb_favorite_repository.dart';
import '../data/repository/firebase/fb_mechanic_repository.dart';
import '../data/repository/firebase/fb_user_repository.dart';
import '../data/repository/interfaces/remote/i_ads_repository.dart';
import '../data/repository/interfaces/remote/i_address_repository.dart';
import '../data/repository/interfaces/remote/i_boardgame_repository.dart';
import '../data/repository/interfaces/remote/i_favorite_repository.dart';
import '../data/repository/interfaces/remote/i_mechanic_repository.dart';
import '../data/repository/interfaces/remote/i_user_repository.dart';
import '../data/repository/interfaces/local/i_local_bag_item_repository.dart';
import '../data/repository/local_data/sqlite/bag_item_repository.dart';
import '../data/repository/local_data/sqlite/bg_names_repository.dart';
import '../data/repository/interfaces/remote/i_bg_names_repository.dart';
import '../data/repository/interfaces/local/i_local_mechanic_repository.dart';
import '../data/repository/local_data/sqlite/mechanic_repository.dart';
import '../data/services/parse_server/parse_server_server.dart';
import '../data/store/database/database_manager.dart';
import '../data/store/stores/bag_item_store.dart';
import '../data/store/stores/bg_names_store.dart';
import '../data/store/stores/interfaces/i_bag_item_store.dart';
import '../data/store/stores/interfaces/i_bg_names_store.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  try {
    // Singletons
    getIt.registerSingleton<IAppPreferencesRepository>(
        AppSharePreferencesRepository());
    getIt.registerSingleton<AppSettings>(AppSettings());
    getIt.registerSingleton<FirebaseMessagingService>(
        FirebaseMessagingService());

    // Lazy Singletons
    getIt.registerLazySingleton<ParseServerService>(() => ParseServerService());
    getIt.registerLazySingleton<MechanicsManager>(() => MechanicsManager());
    getIt.registerLazySingleton<CurrentUser>(() => CurrentUser());
    getIt.registerLazySingleton<SearchFilter>(() => SearchFilter());
    getIt.registerLazySingleton<SearchHistory>(() => SearchHistory());

    // Managers Singletons
    getIt.registerLazySingleton<FavoritesManager>(() => FavoritesManager());
    getIt.registerLazySingleton<AddressesManager>(() => AddressesManager());
    getIt.registerLazySingleton<DatabaseManager>(() => DatabaseManager());
    getIt.registerLazySingleton<BoardgamesManager>(() => BoardgamesManager());
    getIt.registerLazySingleton<AdsManager>(() => AdsManager());
    // Managers Factories
    getIt.registerFactory<MessagesManager>(() => MessagesManager());

    // Parse Server Repositories
    getIt.registerFactory<IUserRepository>(() => FbUserRepository());
    getIt.registerFactory<IMechanicRepository>(() => FbMechanicRepository());
    getIt.registerFactory<IAdsRepository>(() => FbAdsRepository());
    getIt.registerFactory<IBoardgameRepository>(() => FbBoardgameRepository());
    getIt.registerFactory<IAddressRepository>(() => FbAddressRepository());
    getIt.registerFactory<IFavoriteRepository>(() => FbFavoriteRepository());
    getIt.registerFactory<ILocalBagItemRepository>(
        () => SqliteBagItemRepository());
    getIt.registerFactory<IMessageRepository>(() => FbMessageRepository());

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
