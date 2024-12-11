import 'package:flutter/material.dart';

import '/ui/components/state/state_store.dart';

class MessageStore extends StateStore {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }
}
