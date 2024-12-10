import 'chat_store.dart';

class ChatController {
  late final ChatStore store;

  void init(ChatStore store) {
    this.store = store;
  }
}
