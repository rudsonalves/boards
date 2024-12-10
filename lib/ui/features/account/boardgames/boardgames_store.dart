import 'package:flutter/material.dart';

import '../../../components/state/state_store.dart';

class BoardgamesStore extends StateStore {
  final updateBGList = ValueNotifier<bool>(false);

  @override
  void dispose() {
    updateBGList.dispose();

    super.dispose();
  }

  void notifiesUpadteBGList() {
    updateBGList.value = !updateBGList.value;
  }
}
