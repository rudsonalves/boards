import 'package:flutter/material.dart';

import '/data/models/message.dart';
import '/ui/components/state/state_store.dart';

class MessageStore extends StateStore {
  final messageController = TextEditingController();

  final List<MessageModel> messages = [];

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  void setMessages(List<MessageModel> values) {
    messages.clear();
    messages.addAll(values);
  }
}
