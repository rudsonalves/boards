import 'package:flutter/material.dart';

import '/core/models/mechanic.dart';
import '/core/state/state_store.dart';

class CheckMechList {
  final MechanicModel mech;
  final bool _checked;

  CheckMechList(this.mech, this._checked);

  bool get isChecked => _checked;
}

class CheckStore extends StateStore {
  final checkList = ValueNotifier<List<CheckMechList>>([]);

  final count = ValueNotifier<int>(0);

  int counterMax = 0;

  @override
  void dispose() {
    checkList.dispose();
    count.dispose();

    super.dispose();
  }

  void setCheckList(List<CheckMechList> value) {
    checkList.value = value;
  }

  void incrementCount() {
    count.value++;
  }

  void resetCount(int value) {
    count.value = 0;
    counterMax = value;
  }
}
