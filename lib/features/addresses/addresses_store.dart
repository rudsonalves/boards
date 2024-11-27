import 'package:flutter/material.dart';

import '../../core/state/state_store.dart';

class AddressesStore extends StateStore {
  final selectedAddressName = ValueNotifier<String>('');

  void setSelectedAddressName(String addressName) {
    selectedAddressName.value = addressName;
  }

  @override
  void dispose() {
    super.dispose();
    selectedAddressName.dispose();
  }
}
