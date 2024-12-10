import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseServerService {
  late final bool isLocalServer;
  bool isStarted = false;

  Future<void> init(bool isLocalServer) async {
    if (isStarted) return;
    isStarted = true;
    this.isLocalServer = isLocalServer;
    await _start();
  }

  // parse serve declarations
  String get keyApplicationId => isLocalServer
      ? (dotenv.env['APPLICATION_ID_LOCAL'] ?? '')
      : (dotenv.env['APPLICATION_ID'] ?? '');
  String get keyClientKey => isLocalServer
      ? (dotenv.env['CLIENT_KEY_LOCAL'] ?? '')
      : (dotenv.env['CLIENT_KEY'] ?? '');
  String get keyParseServerUrl => isLocalServer
      ? (dotenv.env['PARSE_SERVER_URL_LOCAL'] ?? '')
      : (dotenv.env['PARSE_SERVER_URL'] ?? '');
  String get keyParseServerImageUrl => isLocalServer
      ? (dotenv.env['PARSE_SERVER_IMAGE_URL_LOCAL'] ?? '')
      : (dotenv.env['PARSE_SERVER_IMAGE_URL'] ?? '');

  Future<void> _start() async {
    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      autoSendSessionId: true,
      debug: true,
    );
  }
}
