import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'repository/app_data/interfaces/i_app_preferences_repository.dart';
import 'services/parse_server/parse_server_server.dart';
import 'core/singletons/search_history.dart';
import 'get_it.dart';
import 'data_managers/boardgames_manager.dart';
import 'data_managers/mechanics_manager.dart';
import 'app.dart';
import 'store/database/providers/database_provider.dart';

void main() async {
  const isLocalServer = false;

  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();

  await getIt<IAppPreferencesRepository>().initialize();

  final parseServer = getIt<ParseServerService>();
  parseServer.init(isLocalServer);

  await getIt<IAppPreferencesRepository>().initialize();

  await DatabaseProvider.initialize();

  getIt<SearchHistory>().init();
  await getIt<BoardgamesManager>().initialize();
  await getIt<MechanicsManager>().initialize();

  runApp(const App());
}
